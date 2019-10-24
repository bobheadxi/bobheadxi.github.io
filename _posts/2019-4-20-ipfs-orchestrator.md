---
title: "IPFS Private Network Node Orchestration"
layout: post
date: 2019-04-20 11:00
image: https://upload.wikimedia.org/wikipedia/commons/1/18/Ipfs-logo-1024-ice-text.png
headerImage: true
tag:
- golang
- docker
- ipfs
- grpc
- testing
- tech-writeup
category: blog
author: robert
description: handling deployment, resource management, metadata persistence, and access control for arbitrary IPFS private networks running within Docker containers
---

<p align="center">
    <i>This post is a work in progress - will finish soon! For now, please feel
    free to check out the 
    <a href="https://github.com/RTradeLtd/Nexus" _target="blank">RTradeLTd/Nexus repository</a>.</i>
</p>

<br />

The [Interplanetary Filesystem (IPFS)](https://ipfs.io/) is a piece of tech I've
been working with extensively during my time as a remote software engineer at
[RTrade Technologies](/rtrade-techologies). It's been interesting, but juggling
part-time remote dev work with my [UBC Launch Pad involvement](https://bobheadxi.dev/tags/#launch-pad)
and schoolwork certainly takes a bit of a toll - I'll probably write a blog post
about that at some point.

Anyway - RTrade wanted to explore offering a service that would provide a set of
IPFS nodes, hosted on our end, that customers can use to bootstrap their private
networks - groups of IPFS nodes that only talk to each other. It's a bit of a
underdocumented feature (a quick search for "ipfs private networks" only surfaces
blog posts from individuals about how to manually deploy such a network), and it
kind of goes against the whole "open filesystem" concept of IPFS. That said, it
seemed like it had its use cases - for example, a business could leverage a
private network that used RTrade-hosted nodes as backup nodes of sorts.

So I began work (from scratch) on [Nexus](https://github.com/RTradeLtd/Nexus),
a service that handles on-demand deployment, resource management, metadata
persistence, and fine-grained access control for arbitrary private IPFS networks
running within Docker containers on RTrade infrastructure. This post is a *very*
brief run over some of the high-level components and work that went into the
project, with links to implementation details and whatnot:

* [Deploying Nodes](#deploying-nodes)
* [Orchestrating Nodes](#orchestrating-nodes)
* [Access Control](#access-control)
* [Exposing an API](#exposing-an-api)
* [Testing](#testing)

TODO: a "package map"

## Deploying Nodes

Deploying nodes within containers was the most obvious choice - the tech is kind
of designed for situations like this, and I've had some experience working
directly with the Docker API through my work on [Inertia](/inertia).

This functionality is neatly encapsualted in package [`Nexus/ipfs`](https://godoc.org/github.com/RTradeLtd/Nexus/ipfs)
within an interface, [`ipfs.NodeClient`](https://godoc.org/github.com/RTradeLtd/Nexus/ipfs#NodeClient),
which exposes some faily self-explanatory [C.R.U.D.](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)
functions to manipulate nodes directly:

```go
type NodeClient interface {
	Nodes(ctx context.Context) (nodes []*NodeInfo, err error)
	CreateNode(ctx context.Context, n *NodeInfo, opts NodeOpts) (err error)
	UpdateNode(ctx context.Context, n *NodeInfo) (err error)
	StopNode(ctx context.Context, n *NodeInfo) (err error)
	RemoveNode(ctx context.Context, network string) (err error)
	NodeStats(ctx context.Context, n *NodeInfo) (stats NodeStats, err error)
	Watch(ctx context.Context) (<-chan Event, <-chan error)
}
```

The intention of this API is *purely* to handle the "how" of node deployment,
and not to handle the business logic that goes on to determine the when and
where of deployment. Structures like [`NodeInfo`](https://godoc.org/github.com/RTradeLtd/Nexus/ipfs#NodeInfo)
and [`NodeOpts`](https://godoc.org/github.com/RTradeLtd/Nexus/ipfs#NodeOpts)
expose node configuration that can be used by upper layers:

```go
type NodeInfo struct {
    NetworkID string `json:"network_id"`
    JobID     string `json:"job_id"`

    Ports     NodePorts     `json:"ports"`
    Resources NodeResources `json:"resources"`

    // Metadata set by node client:
    // DockerID is the ID of the node's Docker container
    DockerID string `json:"docker_id"`
    // ContainerName is the name of the node's Docker container
    ContainerName string `json:"container_id"`
    // DataDir is the path to the directory holding all data relevant to this
    // IPFS node
    DataDir string `json:"data_dir"`
    // BootstrapPeers lists the peers this node was bootstrapped onto upon init
    BootstrapPeers []string `json:"bootstrap_peers"`
}
```

The node creation process goes roughly as follows:

1. [Initialize node assets](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/client_utils.go#L47:18)
  on the filesystem - most notably this includes:
   * writing the given "swarm key" (used for identifying a private network) to disk for the node
   * generating an [entrypoint script](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/internal/ipfs_start.sh) that caps resources as required
2. [Setting up configuration](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/client.go#L123), [creating the container](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/client.go#L185), and [getting the container running](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/client.go#L208)
3. [Once the node daemon is ready](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/client_utils.go#L22), [bootstrap the node against existing peers](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/client_utils.go#L83:18) if any peers are configured

Some node configuration is [embedded into the container metadata](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/node.go#L61),
which makes it possible to [recover the configuration from a running container](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/node.go#L143).
This allows the [orchestrator to bootstrap itself](https://github.com/RTradeLtd/Nexus/blob/master/orchestrator/orchestrator.go#L40)
after a restart, and is used by [`NodeClient::Watch()`](https://github.com/RTradeLtd/Nexus/blob/master/ipfs/client.go#L430)
to log and act upon node events (for example, if a node crashes).

This interface neatly abstracts away the gnarly work for upper layers like
the orchestrator:

```go
	if err := o.client.CreateNode(ctx, newNode, opts); err != nil {
    // ...
	}
```

This makes it very easy to generate a mock for testing, which I will talk about
[later in this article](#testing). This particular example is from
[`TestOrchestrator_NetworkUp`](https://sourcegraph.com/github.com/RTradeLtd/Nexus@master/-/blob/orchestrator/orchestrator_test.go#L77),
edited for brevity:

```go
client := &mock.FakeNodeClient{}
o := &Orchestrator{
  Registry: registry.New(l, tt.fields.regPorts),
  client:   client,
  address:  "127.0.0.1",
}
if tt.createErr {
  client.CreateNodeReturns(errors.New("oh no"))
}
if _, err := o.NetworkUp(context.Background(), tt.args.network); (err != nil) != tt.wantErr {
  t.Errorf("Orchestrator.NetworkUp() error = %v, wantErr %v", err, tt.wantErr)
}
```

## Orchestrating Nodes

The core part of Nexus is the predictably named
[`orchestrator.Orchestrator`](https://godoc.org/github.com/RTradeLtd/Nexus/orchestrator#Orchestrator),
which exposes an interface very similar to that of `ipfs.NodeClient`, except
for more high-level "networks". Managed in memory are two registries that cache
the state of the IPFS networks deployed on the server:

* [`registry.Registry`](https://godoc.org/github.com/RTradeLtd/Nexus/registry),
  which basically provides cached information about active containers for faster
  access than constantly querying `dockerd`. It is treated as the live state,
  and is particularly important for access control, which needs to query container
  data very often (more on that later).
* [`network.Registry`](https://godoc.org/github.com/RTradeLtd/Nexus/network),
  which accepts a set of ports from configuration that the orchestrator can
  allocate, and when requested scans ports to provide an available. This is used
  several times during node creation - each node requires a few ports available
  to expose APIs and do things.

The orchestrator also has access to the RTrade database, which does all the
normal making sure a customer has sufficient currency to deploy new nodes
and so on, and syncs the state of deployed networks back to the database. It
also does things like bootstrap networks on startup that should be online that
aren't. Overall it is fairly straight-forward - most of the work is encapsulated
within other components, particularly [`ipfs.NodeClient`](https://godoc.org/github.com/RTradeLtd/Nexus/ipfs#NodeClient).

## Access Control

IPFS nodes expose a set of endpoints on different ports: one for its API, one
for its [gateway](https://github.com/ipfs/go-ipfs/blob/master/docs/gateway.md),
and one for [swarm communication](https://github.com/ipfs/go-ipfs/blob/master/docs/config.md#swarm).
We wanted to be able to expose these to customers without having to either
provide a set of permanent port number on our domain (for example, `nexus.temporal.cloud:1234`)
or asking them to constantly update the ports they connect to. We also wanted to
be able to provide the ability to restrict ports to those with valid RTrade
authentication - particularly the API, which exposes some potentially damaging
functionality.

We eventually decided to aim for the ability to provide customers with a subdomain
of `temporal.cloud` with a scheme like `{network_name}.{feature}.{domain}` (for
example, `my-network.api.nexus.temporal.cloud`) and have Nexus automatically
delegate requests to the appropriate port (where a node from the appropriate
network would be listening for requests).

To do this, I created the (again) predictably named
[`delegator.Engine`](https://godoc.org/github.com/RTradeLtd/Nexus/delegator#Engine)
over the course of two pull requests ([#13](https://github.com/RTradeLtd/Nexus/pull/13),
where I implemented a path-based version of the scheme, and [#22](https://github.com/RTradeLtd/Nexus/pull/22),
where I finally got the subdomain-based routing working) to act as a server for
delegating requests based on the URL scheme we decided on.

The interface exposed by `delegator.Engine` is not particularly self-explanatory,
since most of its functions are designed to work as [go-chi/chi](https://github.com/go-chi/chi)
middleware.

The subdomain routing scheme starts with a [chi `hostrouter`](https://github.com/go-chi/hostrouter),
which [I had to fork to implement wildcard matching](https://github.com/go-chi/hostrouter/pull/6)
(sadly, it seems no one is keeping an eye on the repository, and the PR has gone
unnoticed). Here's a snippet from
[`delegator.Engine::Run()`](https://sourcegraph.com/github.com/RTradeLtd/Nexus@master/-/blob/delegator/engine.go#L111):

```go
    // ...
		hr := hostrouter.New()
		hr.Map("*.api."+e.domain, chi.NewRouter().Route("/", func(r chi.Router) {
			r.Use(e.NetworkAndFeatureSubdomainContext)
			r.HandleFunc("/*", e.Redirect)
		}))
		hr.Map("*.gateway."+e.domain, chi.NewRouter().Route("/", func(r chi.Router) {
			r.Use(e.NetworkAndFeatureSubdomainContext)
			r.HandleFunc("/*", e.Redirect)
    }))
    // ...
```

What this does is listen for all requests to `*.api.nexus.temporal.cloud`, for
example, and route them through an unpleasantly named context injector
([`delegator.Engine::e.NetworkAndFeatureSubdomainContext`](https://sourcegraph.com/github.com/RTradeLtd/Nexus@master/-/blob/delegator/engine.go#L216:18))
and feed requests to the redirector ([`delegator.Engine::Redirect`](https://sourcegraph.com/github.com/RTradeLtd/Nexus@master/-/blob/delegator/engine.go#L247)). The former more or less does as its name describes: it parses
the network (a name) and feature (`api`, `gateway`, etc.), retrieves metadata
about the network from the previously mentioned node registry, and injects it
into the request's `context.Context`. This is a inexpensive operation, since the
node registry is implemented as an in-memory cache. Subsequent handlers can then
use the injected metadata by retrieving it from the context to do whatever they
need to do.

```go
func (e *Engine) NetworkAndFeatureSubdomainContext(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    // ...
		next.ServeHTTP(w, r.WithContext(
			context.WithValue(
				context.WithValue(r.Context(),
					keyFeature, // context key
					feature), // value
				keyNetwork, // context key
        &node), // value
  }
}
```

For most request, the subsequent handler is the redirect handler:

```go
// Redirect manages request redirects
func (e *Engine) Redirect(w http.ResponseWriter, r *http.Request) {
	// retrieve network
	n, ok := r.Context().Value(keyNetwork).(*ipfs.NodeInfo)
	if !ok || n == nil {
		res.R(w, r, res.Err(http.StatusText(422), 422))
		return
	}

	// retrieve requested feature
	feature, ok := r.Context().Value(keyFeature).(string)
	if feature == "" {
		res.R(w, r, res.ErrBadRequest("no feature provided"))
		return
  }

  // do things
```

I'll just take a quick moment to plug my library, [`res`](github.com/bobheadxi/res),
which provides the nice (I think) shorthands for the RESTful responses you see
in the snippet above.

The rest of the code handles each feature case by case, with some notable cases
highlighted in this snippet:

* `api` requests are restricted with authentication using the same JWT we use
  for other RTrade services
* `gateway` access can be disabled via configuration

```go
	switch feature {
	// ...
	case "api":
		// IPFS network API access requires an authorized user
		user, err := getUserFromJWT(r, e.keyLookup, e.timeFunc)
		if err != nil {
			res.R(w, r, res.ErrUnauthorized(err.Error()))
			return
		}
		entry, err := e.networks.GetNetworkByName(n.NetworkID)
		if err != nil {
			http.Error(w, "failed to find network", http.StatusNotFound)
			return
		}
		var found = false
		for _, authorized := range entry.Users {
			if user == authorized {
				found = true
			}
    }
    // ...
    port = n.Ports.API
  case "gateway":
		// Gateway is only open if configured as such
		if entry, err := e.networks.GetNetworkByName(n.NetworkID); err != nil {
			res.R(w, r, res.ErrNotFound("failed to find network"))
			return
		} else if !entry.GatewayPublic {
			res.R(w, r, res.ErrNotFound("failed to find network gateway"))
			return
		}
    port = n.Ports.Gateway
  }
```

At the end of each handling, an appropriate target `port` is set, which is then
used to generate a reverse proxy for this request, edited for brevity:

```go
  // set up target
  var (
		address  = fmt.Sprintf("%s:%s", network.Private, port)
    target   = fmt.Sprintf("%s%s%s", protocol, address, r.RequestURI)
    protocol = "http://"
	)
	if r.URL.Scheme != "" {
		protocol = r.URL.Scheme + "://"
	}
  url, err := url.Parse(target)
  // ...

	// set up forwarder, retrieving from cache if available, otherwise set up new
	var proxy *httputil.ReverseProxy
	if proxy = e.cache.Get(fmt.Sprintf("%s-%s", n.NetworkID, feature)); proxy == nil {
		proxy = newProxy(feature, url, e.l, e.direct)
		e.cache.Cache(fmt.Sprintf("%s-%s", n.NetworkID, feature), proxy)
	}

	// serve proxy request
	proxy.ServeHTTP(w, r)
```

In classic Go-batteries-included fashion, most of the work is done by a nice
utility straight from the standard library: [httputil.ReverseProxy](https://golang.org/pkg/net/http/httputil/#ReverseProxy) -
all [I really had to do was implement a `Director`](https://sourcegraph.com/github.com/RTradeLtd/Nexus@master/-/blob/delegator/proxy.go#L12)
to set the parameters such as every request will be delivered to the correct
node's correct doorstep:

```go
func newProxy(feature string, target *url.URL, l *zap.SugaredLogger, direct bool) *httputil.ReverseProxy {
	return &httputil.ReverseProxy{
		Director: func(req *http.Request) {
			// if set up as an indirect proxy, we need to remove delgator-specific
			// leading elements, e.g. /networks/test_network/api, from the path and
			// accomodate for specific cases
			if !direct {
				switch feature {
				case "api":
					req.URL.Path = "/api" + stripLeadingSegments(req.URL.Path)
				default:
					req.URL.Path = stripLeadingSegments(req.URL.Path)
				}
			}
			// set other URL properties
			req.URL.Scheme = target.Scheme
			req.URL.Host = target.Host
		},
	}
}
```

These reverse proxies are cached so that the delegator doesn't have to construct
them all the time, with evictions based on expiry so that outdated proxies don't
persist for too long.

## Exposing an API

TODO

https://godoc.org/github.com/RTradeLtd/grpc/nexus
https://godoc.org/github.com/RTradeLtd/Nexus/daemon
https://godoc.org/github.com/RTradeLtd/Nexus/client
https://github.com/bobheadxi/ctl

```sh
$> nexus ctl help
$> nexus -dev ctl StartNetwork Network=test-network
$> nexus -dev ctl NetworkStats Network=test-network
$> nexus -dev ctl StopNetwork Network=test-network
```

## Testing

TODO
