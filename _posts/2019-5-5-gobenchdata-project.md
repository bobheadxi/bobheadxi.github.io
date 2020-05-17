---
title: ":chart_with_downwards_trend: Continuous Benchmarking GitHub Action"
layout: post
date: 2019-04-23 12:19
tag:
- golang
- benchmarking
- visualisation
- cli
- automation
- vue
- typescript
image: https://github.com/bobheadxi/gobenchdata/blob/master/.static/demo-chart.png?raw=true
headerImage: false
open_source: true
hidden: true # don't count this post in blog pagination
description: "<i>gobenchdata</i> - Run Go benchmarks, publish results to an interactive web app, and check for performance regressions in your pull requests"
category: open-source
author: robert
star: true
externalLink: false
badges:
- <img src="https://img.shields.io/badge/github-action-yellow.svg" alt="GitHub Action" />
- <img src="https://img.shields.io/github/stars/bobheadxi/gobenchdata.svg?" />
- <img src="https://img.shields.io/website/https/gobenchdata.bobheadxi.dev.svg?down_color=grey&down_message=offline&label=demo&up_message=live" alt="demo status">
- <img src="https://img.shields.io/github/languages/top/bobheadxi/gobenchdata.svg?colorB=1e90ff" />
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
  <a href="https://github.com/bobheadxi/gobenchdata/actions?workflow=pipeline">
    <img src="https://github.com/bobheadxi/gobenchdata/workflows/pipeline/badge.svg" alt="CI Status" />
  </a>
  <a href="https://github.com/bobheadxi/gobenchdata">
    <img src="https://img.shields.io/github/stars/bobheadxi/gobenchdata.svg?" />
  </a>
  <a href="https://bobheadxi.dev/r/gobenchdata">
    <img src="https://img.shields.io/badge/view-github%20action-yellow.svg" alt="GitHub Action" />
  </a>
  <a href="https://gobenchdata.bobheadxi.dev/">
    <img src="https://img.shields.io/website/https/gobenchdata.bobheadxi.dev.svg?down_color=grey&down_message=offline&label=demo&up_message=live" alt="demo status">
  </a>
</p>

`gobenchdata` is a tool for parsing and inspecting `go test -bench` data, and a [GitHub Action](https://github.com/features/actions) for continuous benchmarking. It was inspired by the [`deno.land` continuous benchmarks](https://deno.land/benchmarks.html), which aims to display performance improvements and regressions on a continuous basis.

### Command Line App

* converts Go benchmark data to JSON and handles as saving, merging, and managing datasets of benchmark runs
* generates a web app that instantly provides a visualisation of your benchmark performance over time
* comparing benchmark runs on different branches and enforcing performance requirements with a highly configurable set of options:

```yml
checks:
- name: My Check
  description: |-
    Define a check here - in this example, we caculate % difference for NsPerOp in the diff function.
    diff is a function where you receive two parameters, current and base, and in general this function
    should return a negative value for an improvement and a positive value for a regression.
  package: .
  benchmarks: [ BenchmarkA, BenchmarkB ]
  diff: (current.NsPerOp - base.NsPerOp) / base.NsPerOp * 100
  thresholds:
    max: 10
```

### GitHub Action

The CLI can also be leveraged in [GitHub Actions](https://github.com/features/actions). Setup for the Action is very simple:

{% raw %}

```yml
name: gobenchdata publish
on: push
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - name: gobenchdata publish
      uses: bobheadxi/gobenchdata@v1
      with:
        PRUNE_COUNT: 30
        GO_TEST_FLAGS: -cpu 1,2
        PUBLISH: true
        PUBLISH_BRANCH: gh-pages
      env:
        GITHUB_TOKEN: ${{ secrets.ACCESS_TOKEN }}
```

{% endraw %}

The Action can also be used to perform regression checks on benchmark results.

Drop by the [repository](https://github.com/bobheadxi/gobenchdata) to learn more!

<br />
