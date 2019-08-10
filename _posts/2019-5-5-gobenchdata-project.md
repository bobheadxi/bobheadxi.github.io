---
title: ":chart_with_downwards_trend: Continuous Benchmarking GitHub Action"
layout: post
date: 2019-04-23 12:19
tag:
- golang
- javascript
- benchmarking
- data-viz
- cli
- automation
image: ""
headerImage: false
open_source: true
hidden: true # don't count this post in blog pagination
description: "<i>gobenchdata</i> - CLI for inspecting Go benchmarking outputs, GitHub Action for continuous benchmarking, and web app for performance visualization"
category: open-source
author: robert
star: true
externalLink: false
badges:
- <img src="https://img.shields.io/badge/github-action-yellow.svg" alt="GitHub Action" />
- <img src="https://img.shields.io/website/https/gobenchdata.bobheadxi.dev.svg?down_color=grey&down_message=offline&label=demo&up_message=live" alt="demo status">
---

<p align="center">
  <a href="https://gobenchdata.bobheadxi.dev"> 
    <img src="https://github.com/bobheadxi/gobenchdata/blob/master/.static/demo-chart.png?raw=true" alt="demo">
  </a>
</p>

<p align="center">
  <a href="https://github.com/bobheadxi/gobenchdata">    
    <img src="https://img.shields.io/badge/github-gobenchdata-red.svg?style=for-the-badge" alt="GitHub Repository"/>
  </a>
</p>

<p align="center">
  <a href="https://dev.azure.com/bobheadxi/bobheadxi/_build/latest?definitionId=7&branchName=master">
    <img src="https://dev.azure.com/bobheadxi/bobheadxi/_apis/build/status/bobheadxi.gobenchdata?branchName=master" alt="CI Status" />
  </a>
  <a href="https://github.com/marketplace/actions/gobenchdata-to-gh-pages">
    <img src="https://img.shields.io/badge/view-action-yellow.svg" alt="GitHub Action" />
  </a>
  <a href="https://godoc.org/github.com/bobheadxi/gobenchdata">
    <img src="https://godoc.org/github.com/bobheadxi/gobenchdata?status.svg" alt="GoDoc" />
  </a>
  <a href="https://gobenchdata.bobheadxi.dev/">
    <img src="https://img.shields.io/website/https/gobenchdata.bobheadxi.dev.svg?down_color=grey&down_message=offline&label=demo&up_message=live" alt="demo status">
  </a>
</p>

`gobenchdata` is a tool for inspecting `go test -bench` data, a
[GitHub Action](https://github.com/features/actions) for continuous benchmarking,
and a web app for performance visualization.

It features:

* a CLI for converting Go benchmark data in JSON as well as saving, merging, and
  managing datasets of benchmark runs
* a GitHub Action that allows simple setup of continuous benchmarking
* a CLI for generating a web app that instantly provides a visualization of your
  benchmark performance over time

Setup for the Action is very simple:

```hcl
workflow "Benchmark" {
  on = "push"
  resolves = ["gobenchdata to gh-pages"]
}

action "filter" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "gobenchdata to gh-pages" {
  uses = "bobheadxi/gobenchdata@master"
  needs = ["filter"]
  secrets = ["GITHUB_TOKEN"]
  env = {
    PRUNE = "20"
  }
}
```

Then, a user can simply run `gobenchdata-web` to generate a web app that they
can commit to their `gh-pages` branch, as demonstrated [here](https://gobenchdata.bobheadxi.dev).

Drop by the [repository](https://github.com/bobheadxi/gobenchdata) to learn more!

<br />