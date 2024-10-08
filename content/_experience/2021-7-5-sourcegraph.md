---
title: "Software Engineer"
layout: post
tag:
- remote
- sourcegraph
- golang
- postgres
image: /assets/images/experience/sourcegraph.png
headerImage: true
company: sourcegraph
organisation: "Sourcegraph, Inc."
orgLink: https://about.sourcegraph.com
description: "July 2021 - Present | Remote"
author: robert
---

Since July 2021, I have been working as a software engineer at [Sourcegraph](#about-sourcegraph) in various teams across the company over time.

- [Core Services](#core-services)
- [Sourcegraph Cloud](#sourcegraph-cloud)
- [Developer experience](#developer-experience)

## Core Services

With the launch of Sourcegraph's [AI coding assistant, Cody](https://sourcegraph.com/cody), and a new focus on product-led growth as opposed to Sourcegraph's traditionally enterprise and on-prem customer base, I joined the newly formed "Core Services" team in September 2023 to build the foundations of cloud-first services at Sourcegraph. Shortly after joining the team, I was assigned as the team's technical lead.

## Sourcegraph Cloud

As Sourcegraph [pivoted](https://about.sourcegraph.com/blog/single-tenant-cloud) towards prioritising our [managed single-tenant Sourcegraph Cloud offering](https://docs.sourcegraph.com/cloud), I joined the [Cloud team](https://handbook.sourcegraph.com/departments/cloud/) in October 2022 to build out the next-generation platform for deploying and operating hundreds of Sourcegraph instances for customers. I worked on the Cloud team for around 11 months, during which I worked on:

- designing and building our next-generation [Sourcegraph Cloud instances control plane](../_posts/2024-8-23-multi-single-tenant.md)
- conducting the vendor evaluation and implementation of out-of-the-box SMTP (email delivery) capabilities for Sourcegraph Cloud instances

## Developer experience

The [Developer Experience team's](https://handbook.sourcegraph.com/departments/product-engineering/engineering/enablement/dev-experience) mission is to make it so that every developer feels empowered to be productive in contributing to the Sourcegraph application.

During my 15 months as part of the Developer Experience team, I contributed extensively to:

- [`sg`, the Sourcegraph developer tool](https://docs.sourcegraph.com/dev/background-information/sg), in particular building out a infrastructure to [allow development of `sg` to scale](../_posts/2022-10-10-investing-in-development-of-devx.md)
- Sourcegraph's continuous integration infrastructure and CI pipeline generator
- the Sourcegraph monitoring generator, which manages converting monitoring definitions into integrations with Sourcegraph's monitoring ecosystem like Grafana dashboards, Prometheus Alertmanager alerts, and generated alert response documentation.
- driving the discussion, implementation, and adoption of [standardised logging](https://github.com/sourcegraph/sourcegraph-public-snapshot/pull/33956) and [OpenTelemetry](https://github.com/sourcegraph/sourcegraph-public-snapshot/issues/39397) in Sourcegraph
- designing and building a new architecture for [scalable, stateless continuous integration agents](../_posts/2022-4-18-stateless-ci.md)

...and more.

In addition to work directly related to the Developer Experience teams' ownership areas, I also contributed to other parts of the core Sourcegraph application during my time with the team, such as:

- [scaling GitHub permissions mirroring](../_posts/2021-10-8-mirroring-github-permissions-at-scale.md) for large enterprises and supporting the continued maintenance of Sourcegraph's permissions syncing systems
- designing and developing [an extended permissions model for Sourcegraph](https://github.com/sourcegraph/sourcegraph-public-snapshot/issues/27916), notably [implementing expanded access control parsing for Perforce](https://github.com/sourcegraph/sourcegraph-public-snapshot/pull/26745)

<br />

### About Sourcegraph

[Sourcegraph](https://about.sourcegraph.com/about) provides code search and intelligence on the web across massive collections of codebases.
Sourcegraph is a fully distributed company with employees across the world.

Interested in joining? [We're hiring](https://about.sourcegraph.com/jobs/)!
