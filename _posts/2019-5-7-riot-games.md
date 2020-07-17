---
title: "Software Engineer Intern"
layout: post
date: 2019-05-07 9:00
tag:
- internship
- golang
- graph-databases
- monitoring
- react
- visualisation
- riot-games
image: /assets/images/experience/riot-games.png
headerImage: true
experience: true
company: riot-games
hidden: true # don't count this post in blog pagination
organisation: "Riot Games, Inc"
orgLink: https://www.riotgames.com/en/who-we-are
description: "May 2019 - August 2019 | Los Angeles, CA"
category: experience
author: robert
externalLink: false
---

<p align="center">
    <img src="/assets/images/posts/riot-alerts-explorer-wide.png" />
</p>

<p align="center">
    <i style="font-size:90%;">
    The alert visualisation tool I made, as seen in
    <a href="https://technology.riotgames.com/news/technology-interns-riot-games">
    a blog post I contributed to on the official Riot Games Technology blog</a>.
    </i>
</p>

<br />

From May to August 2019, I worked as a software engineering intern at Riot Games in the Operability team under a group called Riot Developer Experience, which aspires to simplify the foundation for developing and operating services, empowering teams to focus on their own problem spaces. Operability specifically owns a variety of systems within Riot Games, though our work at the time mostly pertained to operational monitoring - providing engineers at Riot visibility into how their services are performing and behaving across the globe.

During my time at Riot Games, I primarily worked on two projects in this space:

## Deployable Artefact Specification Extension

The first was designing and building an extension to Riot’s deployable artefact specification to allow declarative specification of alerts on services. The specification allows engineers to describe how to deploy (similar to a Kubernetes manifest) and maintain a service for operators in various Riot regions. The extension I worked on for this specification would give these operators additional context on what metrics emitted by a service are important to track, while giving engineers in Riot regions an automated way to deploy alerts for service metrics through our deployment service. This work was split into several parts: designing and implementing the extension specification, and implementing the complete deployment flow for alerts as part of our internal deployment frameworks.

```yml
alerts:
  metric: queue.size
  threshold:
  - type: max
    value: SELECT(configuration[name='my_queue.max_queue_size'].value) * 0.75
```

This project used Golang for integrating with our Golang-based deployment orchestrator, configuration manipulation, and usage of both 3rd-party and internal APIs to manipulate data. It required updating a variety of Golang-based libraries and tools used at the company as well. Along the way, I made a variety of contributions to fix bugs I encountered. Designing the specification required extensive writeups, experimentation, and going through our internal RFC (Request For Comment) process.

See [this blog post](/evaluable-expressions) for a writeup about a small chunk of work I did for this project!

## Alert Visualisation

The second project was a service for holistically looking at all alerts firing across Riot, and constructing a graph of them based on the associated data centres, related applications, network topography, and more to aid in triage and root cause analysis of events. Doing so allows engineers to ask questions about alerts based on relations. For example, how soon was alert A fired after alert B? Do they have a network dependency between them? Are they owned by the same team? Do they all happen to be in the same datacenter? The goal was to help engineers triage the root cause of issues that might cause a cascade of alerts across Riot’s microservice ecosystem through a flexible, interactive, and extensible visualisation tool.

<p align="center">
    <img src="https://technology.riotgames.com/sites/default/files/intern12-robert3.png" width="70%" />
</p>

<p align="center">
    <i style="font-size:90%;">
    An example diagram of the sorts of relationships I was interested in visualising between alerts, as seen in
    <a href="https://technology.riotgames.com/news/technology-interns-riot-games">
    a blog post I contributed to on the official Riot Games Technology blog</a>.
    </i>
</p>

This project was built on Golang, usage of 3rd-party APIs, internal APIs, and MongoDB access to query for data, and leveraged the [Cayley graph database](https://github.com/cayleygraph/cayley) internally for maintaining active alert relationships. It runs as a service and web application that continuously monitors alerts and maintains a sliding window of alert relations that can be queried and visualised in the web application through a query builder I implemented. Additional "layers" can be easily implemented through the service's plugin system to provide more context on potential relationships between alerts.

<p align="center">
    <img src="https://technology.riotgames.com/sites/default/files/intern11-robert2.png" />
</p>

<p align="center">
    <i style="font-size:90%;">
    Another view of the alert visualizer, demonstrating the query builder and a simple interactive visualisation.
    Labels can be toggled for the nodes and edges in the right panel.
    </i>
</p>

The project featured an interactive display of relationships, allowing users to reposition and drag
around the nodes easily, as well as a query interface where users can either write raw queries
themselves using [a graph query language](https://github.com/cayleygraph/cayley/blob/master/docs/gizmoapi.md)
or construct queries using the parameterized builder I created, as seen in the screenshot above.

<br />

<hr />

### About Riot Games

[Riot Games](https://www.riotgames.com/en/who-we-are) is the company behind
*[League of Legends](https://na.leagueoflegends.com/en/)*, one of the most-played
PC video games in the world with an estimated playerbase of about
[8 million peak concurrent players every day - higher than the top 10 games on Steam combined](https://na.leagueoflegends.com/en/news/game-updates/special-event/join-us-oct-15th-celebrate-10-years-league).
They are currently headquartered in Los Angeles, California, and have 2,500+
employees in 20+ offices worldwide.
