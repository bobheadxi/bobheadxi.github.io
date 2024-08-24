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

Since July 2021, I have been working as a software engineer at [Sourcegraph](#about-sourcegraph), firstly in the the newly created [Developer Experience team](#developer-experience) for about 5 months and later in the [Sourcegraph Cloud team](#sourcegraph-cloud).

Most of the company's work is open-source (to a lesser extent on the Sourcegraph Cloud team), so you can [see some of my contributions for Sourcegraph on GitHub](https://github.com/search?q=org%3Asourcegraph+author%3Abobheadxi+is%3Amerged+created%3A%3E2021-05-01&type=pullrequests&s=comments&o=desc)!

## Core Services

With the launch of Sourcegraph's [AI coding assistant, Cody](https://sourcegraph.com/cody), and a new focus on product-led growth as opposed to Sourcegraph's traditionally enterprise and on-prem customer base, I joined the newly formed "Core Services" team in September 2023 to build the foundations of cloud-first services at Sourcegraph. Shortly after joining the team, I was assigned as the team's technical lead.

## Sourcegraph Cloud

As Sourcegraph [pivoted](https://about.sourcegraph.com/blog/single-tenant-cloud) towards prioritising our [managed single-tenant Sourcegraph Cloud offering](https://docs.sourcegraph.com/cloud), I joined the [Cloud team](https://handbook.sourcegraph.com/departments/cloud/) in October 2022 to build out the next-generation platform for deploying and operating hundreds of Sourcegraph instances for customers. I worked on the Cloud team for around 11 months.

## Developer experience

The [Developer Experience team's](https://handbook.sourcegraph.com/departments/product-engineering/engineering/enablement/dev-experience) mission is to make it so that every developer feels empowered to be productive in contributing to the Sourcegraph application.

As part of the Developer Experience team, I've contributed extensively to:

- [`sg`, the Sourcegraph developer tool](https://docs.sourcegraph.com/dev/background-information/sg), in particular building out a infrastructure to [allow development of `sg` to scale](../_posts/2022-10-10-investing-in-development-of-devx.md)
- Sourcegraph's continuous integration infrastructure and [pipeline generator](https://sourcegraph.com/notebooks/Tm90ZWJvb2s6MTE3)
- the [Sourcegraph monitoring generator](https://docs.sourcegraph.com/dev/background-information/observability/monitoring-generator)
- driving the discussion, implementation, and adoption of [standardised logging](https://github.com/sourcegraph/sourcegraph/pull/33956) and [OpenTelemetry](https://github.com/sourcegraph/sourcegraph/issues/39397) in Sourcegraph
- [developing libraries](https://github.com/sourcegraph/run) for [ease of migration from Bash scripts](https://github.com/sourcegraph/sourcegraph/blob/main/doc/dev/adr/1652433602-use-go-for-scripting.md)
- designing and building a new architecture for [scalable, stateless continuous integration agents](../_posts/2022-4-18-stateless-ci.md)
- the [Sourcegraph developer experience newsletter](https://handbook.sourcegraph.com/departments/product-engineering/engineering/enablement/dev-experience/newsletter)

...and more.

In addition to work directly related to the Developer Experience teams' ownership areas, I also contributed to other parts of the core Sourcegraph application during my time with the team, such as:

- [scaling GitHub permissions mirroring](../_posts/2021-10-8-mirroring-github-permissions-at-scale.md) for large enterprises and supporting the continued maintenance of Sourcegraph's permissions syncing systems
- designing and developing [an extended permissions model for Sourcegraph](https://github.com/sourcegraph/sourcegraph/issues/27916), notably [implementing expanded access control parsing for Perforce](https://github.com/sourcegraph/sourcegraph/pull/26745)
- creating [standardised actor propagation tooling](https://sourcegraph.com/notebooks/Tm90ZWJvb2s6OTI=) across services

<br />

### About Sourcegraph

[Sourcegraph](https://about.sourcegraph.com/about) provides code search and intelligence on the web across massive collections of codebases.
Sourcegraph is a fully distributed company with employees across the world.

Interested in joining? [We're hiring](https://about.sourcegraph.com/jobs/)!
