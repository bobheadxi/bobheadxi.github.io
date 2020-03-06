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
- data-viz
- riot-games
image: /assets/images/experience/riot-games.png
headerImage: true
experience: true
company: riot-games
hidden: true # don't count this post in blog pagination
organization: "Riot Games, Inc"
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
    The alert visualization tool I made, as seen in
    <a href="https://technology.riotgames.com/news/technology-interns-riot-games">
    a blog post I contributed to on the official Riot Games Technology blog</a>.
    </i>
</p>

<br />

From May to August 2019, I worked as a software engineering intern on the Operability team under
a group called Riot Developer Experience, which aspires to simplify the foundation for developing
and operating services, empowering teams to focus on their own problem spaces.
Operability specifically owns a variety of systems within Riot Games, though our work at the time mostly
pertained to operational monitoring - providing engineers at Riot visibility into how their
services are performing and behaving across the globe.

During my time there I worked on two projects in this space:

## Deployable Artifact Specification Extension

The first was designing and building an extension to Riot’s deployable artifact specification to allow declarative specification of alerts on services. The specification allows operators in various Riot regions a way to discover how to deploy and monitor a service. This extension would give these operators additional context on what metrics emitted by a service are important to track, while giving engineers in Riot regions an automated way to deploy alerts through our deployment service. This work was split into several parts: designing and implementing the extension specification, and implementing the complete deployment flow for alerts as part of our internal deployment frameworks.

This project required pretty involved Golang for configuration manipulation, usage of both 3rd-party and internal APIs to manipulate data, and integrating with our Golang-based deployment orchestrator.

See [this blog post](/evaluable-expressions) for a writeup about a small chunk of work I did for this project!

## Alert Visualization

The second project was a tool for holistically looking at all alerts firing across Riot, and constructing a graph of them based on the associated data centers, related applications, network topography, and more to aid in triage and root cause analysis of events. Doing so allows engineers to ask questions about alerts based on relations. For example, how soon was alert A fired after alert B? Do they have a network dependency between them? Are they owned by the same team? Do they all happen to be in the same datacenter? The goal was to help engineers triage the root cause of issues that might cause a cascade of alerts across Riot’s microservice ecosystem through a flexible visualization tool.

This project was built on Golang, usage of 3rd-party APIs, internal APIs, and MongoDB access to query for data, and leveraged the [Cayley graph database](https://github.com/cayleygraph/cayley) for maintaining active alert relationships.

See the image at the top of this page for a peek at what the final product looked like!

<br />

<hr />

### About Riot Games

[Riot Games](https://www.riotgames.com/en/who-we-are) is the company behind
*[League of Legends](https://na.leagueoflegends.com/en/)*, one of the most-played
PC video games in the world with an estimated playerbase of about
[8 million peak concurrent players every day - higher than the top 10 games on Steam combined](https://na.leagueoflegends.com/en/news/game-updates/special-event/join-us-oct-15th-celebrate-10-years-league). 
They are currently headquartered in Los Angeles, California, and have 2,500+
employees in 20+ offices worldwide.
