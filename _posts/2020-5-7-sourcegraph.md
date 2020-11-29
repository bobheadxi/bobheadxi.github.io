---
title: "Software Engineer Intern"
layout: post
date: 2020-01-07 9:00
tag:
- internship
- golang
- typescript
- graphql
- docker
- kubernetes
- monitoring
- sourcegraph
image: /assets/images/experience/sourcegraph.png
headerImage: true
experience: true
company: sourcegraph
hidden: true # don't count this post in blog pagination
organisation: "Sourcegraph, Inc."
orgLink: https://about.sourcegraph.com
description: "May 2020 - Present | Remote"
category: experience
author: robert
externalLink: false
---

Since May 2020, I have been working as a software engineering intern at [Sourcegraph](#about-sourcegraph) on the [Distribution team](https://about.sourcegraph.com/handbook/engineering/distribution). The Distribution team is responsible for making Sourcegraph easy to deploy, scale, monitor, and debug, solving challenging problems that our customers face when they deploy and scale Sourcegraph on-premise in a variety of environments, and that we face when we deploy and scale [Sourcegraph Cloud](https://sourcegraph.com/search) (the largest Sourcegraph installation in the world).

My work as an intern has had several areas of focus: building out the [monitoring stack that ships with Sourcegraph](#monitoring-at-sourcegraph), improving the [process for creating Sourcegraph releases](#sourcegraph-releases) to on-premise deployments with new capabilities, and experimenting with changes to the [pipelines that help us roll out Sourcegraph changes](#deployment-pipelines) to the various deployments we manage ourselves.

Most of the company's work is open-source, so you can [see my pull requests for Sourcegraph on GitHub](https://github.com/search?o=desc&q=org%3Asourcegraph+author%3Abobheadxi+is%3Amerged&s=comments&type=Issues)! If you poke around, you might spot me chiming in on a variety of other pull requests and issue discussions as well.

<br />

## Monitoring at Sourcegraph

During my time at Sourcegraph, a major part of my focus has been on expanding the capabilities of Sourcegraph's built-in monitoring stack and improving the experience for:

* Administrators of Sourcegraph deployments, by making it easy to configure alerts and provide diagnostics to help us triage their issues
* Sourcegraph engineers, by improving the flexibility of our tooling for adding monitoring for their features and services, and adding container monitoring using cAdvisor to all our deployments
* Sourcegraph support, by unifying and updating our existing Prometheus queries, improving the generated solution documentations for alerts, and integrating team ownership for easier triage of support requests and paging

<p align="center">
    <img src="https://storage.googleapis.com/sourcegraph-assets/monitoring-architecture.png" />
</p>

<p align="center">
    <i style="font-size:90%;">
    A diagram of the monitoring stack that we ship to customers as part of each Sourcegraph deployment. Learn more about it in
    <a href="https://about.sourcegraph.com/handbook/engineering/observability/monitoring_architecture">our handbook entry</a> that I
    <a href="https://github.com/sourcegraph/about/pull/1221">helped write</a>!
    </i>
</p>
<br />

Some specific examples of the work I did to enable this include:

* I created a new sidecar service to ship with the [Sourcegraph Prometheus image](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/tree/docker-images/prometheus), which I wrote a bit about in [this blog post](/docker-sidecar/). It allowed us to build integrations with alerting configuration directly into the Sourcegraph application, as well as monitoring features such as the ability to include recent alerts data in bug reports. I eventually used this sidecar to implement a [proposal for routing alerts to the teams that own them](https://github.com/sourcegraph/sourcegraph/issues/12010).

* I made a variety of contributions to our [monitoring generator](https://github.com/sourcegraph/sourcegraph/tree/main/monitoring), which generates the Grafana dashboards, Prometheus rules and alerts definitions, documentation, and more that ship with Sourcegraph from a [custom monitoring specification](https://github.com/sourcegraph/sourcegraph/blob/main/monitoring/monitoring/README.md) that teams use to declare monitoring relevant to their services. I also drove cross-team discussions to [overhaul the principles that drive our work on this tooling](https://github.com/sourcegraph/about/pull/2000) to help guide the future of monitoring at Sourcegraph.

<br />

## Sourcegraph Releases

Previously, creating Sourcegraph releases was a lengthy, complex process that involved a large number of manual steps that would frequently delay our monthly releases.

My work in this area includes:

* Extensive improvements to the [Sourcegraph release tool](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/tree/dev/release), which handles automation of release tasks such as generating multi-repository changes, creating tags, setting up tracking issues, adding calendar events, making announcements, and more

* Improving our integration and regression testing suite by introducing the capability to directly leverage candidate images in tests, generalising test setup tooling, and adding automated upgrade tests to ensure compatibility

The long-term vision of this work is to enable releases to be handled by any engineer at Sourcegraph, as seamlessly and painlessly as possible, improving the pace at which we can confidently ship releases to our customers.

<p align="center">
    <img src="https://user-images.githubusercontent.com/23356519/99866490-8d6ded80-2bec-11eb-8c1a-da84f4c352c3.png" />
</p>

<p align="center">
    <i style="font-size:90%;">
    A generated release campaign providing release captains an overview of the changes required for a Sourcegraph release to happen.
    <a href="https://docs.sourcegraph.com/campaigns">Sourcegraph campaigns</a> was a feature undergoing extensive development by another team, and I made this fun integration to build to check out their work and help out our own team's management of releases!
    </i>
</p>

<br />

## Deployment Pipelines

Sourcegraph maintains a [variety of Sourcegraph instances in addition to Sourcegraph Cloud](https://about.sourcegraph.com/handbook/engineering/deployments/instances). Deployment at Sourcegraph generally consists of two distinct steps:

* Building and publishing images

* Propagating published images

You can read more about this in [the handbook page about instances](https://about.sourcegraph.com/handbook/engineering/deployments/instances).

I worked on making adjustments to our build and publish pipelines, such as enabling direct integration testing of candidate images and making it easier to build tooling that interacts with our images.

Deployment methodology varies from instance to instance, but when I first joined Sourcegraph we did not have any instance that was kept closely up to date synchronously with both the state of our monorepo, [`sourcegraph/sourcegraph`](https://github.com/sourcegraph/sourcegraph), and the state of our primary method of distributing Sourcegraph, [`sourcegraph/deploy-sourcegraph`](https://github.com/sourcegraph/deploy-sourcegraph). To amend this, I built a trigger-based pipeline that would keep `deploy-sourcegraph` in sync with the latest images, and immediately propagate changes in `deploy-sourcegraph` to an [internal dogfood instance](https://about.sourcegraph.com/handbook/engineering/deployments/instances#k8s-sgdev-org).

<br />

### About Sourcegraph

[Sourcegraph](https://about.sourcegraph.com/about) provides code search and intelligence on the web across massive collections of codebases. Their long-term vision is to make it so everyone, in every community, in every country, and in every industry — not just the ones working at the half-dozen dominant tech companies — can create products using the best technology. Sourcegraph is a fully distributed company with employees across the world.
