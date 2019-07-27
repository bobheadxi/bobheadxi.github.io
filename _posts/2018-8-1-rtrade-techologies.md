---
title: "Software Engineer"
layout: post
date: 2018-08-01 12:00
tag:
- remote
- golang
- ipfs
- grpc
- docker
- postgres
image: https://static1.squarespace.com/static/5c905abba9ab952f9d5f10cc/t/5c999caf86222e0001c7b6c4/1554999397417
headerImage: true
experience: true
hidden: true # don't count this post in blog pagination
organization: RTrade Technologies Ltd.
orgLink: https://www.rtradetechnologies.com/
description: "Sept 2018 - April 2019 | Vancouver, BC"
category: experience
author: robert
externalLink: false
---

From September 2018 to April 2019, I worked remotely part-time while taking classes
at UBC on RTrade's primary product [Temporal](https://temporal.cloud/) (an API
interface into distributed and decentralized storage technologies) and its related services.
My work involved leveraging technologies like [Golang](https://golang.org/),
[Docker](https://www.docker.com/), [gRPC](https://grpc.io/),
[PostgreSQL](https://www.postgresql.org/), and [IPFS](https://ipfs.io/)
(a globally distributed filesystem) across projects such as:

* **designing, building, and deploying a new [IPFS node orchestration and registry agent](https://github.com/RTradeLtd/Nexus)**
  that serves as the backbone for Temporal's private network service. The service
  handles automated and on-demand deployment, resource management, metadata persistence,
  and fine-grained access control for IPFS nodes running within Docker containers.
* revamping [RTrade's **search engine service**](https://github.com/RTradeLtd/Lens)
  for improved results, more structured data management, improved performance,
  a new gRPC-based API, and new features like OCR capabilities
* building and integrating a new [object encryption/decryption tool](https://github.com/RTradeLtd/crypto)
  for assets stored by customers on the service 
* [establishing a framework](https://github.com/RTradeLtd/testenv) for quickly
  deploying production-like test environments for **effective integration testing**
* refactoring the core codebase into [extensible and reusable packages](https://github.com/search?q=topic%3Atemporal+org%3ARTradeLtd+fork%3Atrue)

Most of the company's work is open-source, so you can see all my pull requests
for RTrade on [GitHub](https://github.com/search?o=asc&q=author%3Abobheadxi+is%3Amerged+org%3ARTradeLtd&s=created&type=Issues)!
