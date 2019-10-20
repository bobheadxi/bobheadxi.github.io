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
[RTrade Technologies](/rtrade-techologies). We wanted to explore
offering a service that would provide a set of IPFS nodes, hosted on our end,
that customers can use to bootstrap their private networks - groups of IPFS nodes
that only talk to each other.

So I began work on [Nexus](https://github.com/RTradeLtd/Nexus), the core of the product,
which handles on-demand deployment, resource management, metadata persistence, and
fine-grained access control for private IPFS networks running within Docker
containers on RTrade infrastructure. This post goes over some of the high-level
components and work that went into the project, with links to implementation
details and whatnot:

* [Deploying Nodes](#deploying-nodes)
* [Orchestrating Nodes](#orchestrating-nodes)
* [Access Control](#access-control)
* [Exposing an API](#exposing-an-api)

## Deploying Nodes

Deploying nodes within containers was the most obvious choice - the tech is kind
of designed for situations like this, and I've had some experience working
directly with the Docker API through my work on [Inertia](/inertia).

This functionality is neatly encapsualted in package [`Nexus/ipfs`](https://godoc.org/github.com/RTradeLtd/Nexus/ipfs)
within an interface, `ipfs.NodeClient`, which exposes some faily self-explanatory
[C.R.U.D.](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) functions
to manipulate nodes directly:

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

TODO

https://godoc.org/github.com/RTradeLtd/Nexus/orchestrator#Orchestrator
https://godoc.org/github.com/RTradeLtd/Nexus/network
https://godoc.org/github.com/RTradeLtd/Nexus/registry

## Access Control

TODO

https://godoc.org/github.com/RTradeLtd/Nexus/delegator

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
