---
title: ":books: Project Lifetime Visualisation"
layout: post
date: 2019-02-28 12:19
tag:
- golang
- visualisation
- react
- typescript
- redis
- postgres
- graphql
- analytics
image: ""
headerImage: false
open_source: true # hidden for now
hidden: true # don't count this post in blog pagination
description: "<i>Timelines</i> - historical analysis of Git repositories and Git host activity as a service"
category: open-source
author: robert
star: false
externalLink: false
badges: []
---

<p align="center">
    <img src="/assets/images/projects/timelines-banner.png" width="100%" />
</p>

<p align="center">
    <a href="https://github.com/bobheadxi/timelines">
        <img src="https://img.shields.io/badge/github-timelines-orange.svg?style=for-the-badge" alt="GitHub Repository"/>
    </a>
</p>

*Timelines* is probably one of the largest, most comprehensive solo projects
I've ever taken on... and subsequently abandoned. :tada:

I started it in mid-February 2018 after running into a tool called
[Hercules](https://github.com/src-d/hercules), which is a highly customizable
Git repository analysis engine written in Go. It generates a DAG of analysis
tasks to run on a repository and outputs a ton of data observing trends over the
history of a project.

I thought this was a pretty neat take on project histories, especially since for
myself and teams at my club [UBC Launch Pad](https://www.ubclaunchpad.com/), it
can be easy to lose sight of how far we've come in a project. So I decided to
try and turn this concept into a service that tied all sorts of metadata about
your project - Git history analysis, milestones, releases, issues, pull requests,
and more together into a single visualisation of the life of your project.

Over a period of about 4 months, I created:

* the core service as an integration with GitHub Apps
* a job engine to run sync tasks from GitHub and analysis jobs on arbitrary repositories
* PostgreSQL tables and adapters to transform analytics output into a suitable format for storage
* a comprehensive GraphQL API for querying analytics data
* development tooling to help set up mock data on my Redis and PostgreSQL instances
* observability hooks such as runtime profiling and automatic error reporting integrated with my loggers

I also had my service deployed on Heroku and Netlify during this time so that I
could make sure things worked in the environments I wanted to deploy in.

During this time, I also started or improved a few other relevant side projects:

* features for my dependencies (primarily [Hercules](https://bobheadxi.dev/hercules))
  that I needed or wanted
* [logging extensions](https://github.com/bobheadxi/zapx) for the `uber-go/zap` library
* a [continuous benchmarking](https://github.com/bobheadxi/gobenchdata) tool for observing performance trends
* generator for [static, canonical Go package import paths](https://github.com/bobheadxi/twist)

<p align="center">
    <img src="/assets/images/projects/timelines-home.png" width="80%" />
</p>

Unfortunately I've decided to abandon the project for the time being. However,
my work on this has helped inform my other projects a lot, and expanded the
toolset I have available to me.

Check out the [repository](https://github.com/bobheadxi/timelines) to see how far I made it!

<br />
