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

TODO: how this works

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
