---
title: ":muscle: Git Repository Analysis Engine"
layout: post
date: 2019-03-19 12:19
tag:
- golang
- python
- git
- analytics
image: ""
headerImage: false
open_source: true
hidden: true # don't count this post in blog pagination
description: "<i>Hercules</i> - fast, insightful, and highly customizable Git history analysis"
category: open-source
author: robert
star: true
externalLink: false
badges:
- <img src="https://img.shields.io/github/stars/src-d/hercules.svg?" />
- <img src="https://img.shields.io/github/contributors/src-d/hercules.svg" />
---

<p align="center">
    <img src="https://github.com/src-d/hercules/blob/master/doc/dag.png?raw=true" width="100%" />
</p>

<p align="center">
    <a href="https://github.com/src-d/hercules">    
        <img src="https://img.shields.io/badge/github-src--d%2Fhercules-green.svg?style=for-the-badge" alt="GitHub Repository"/>
    </a>
</p>

<p align="center">
    <img src="https://img.shields.io/github/languages/top/src-d/hercules.svg?colorB=1e90ff" />
    <img src="https://goreportcard.com/badge/github.com/src-d/hercules" />
    <a href="https://godoc.org/gopkg.in/src-d/hercules.v9"><img src="https://godoc.org/gopkg.in/src-d/hercules.v9?status.svg" alt="GoDoc"></a>
    <img src="https://img.shields.io/github/stars/src-d/hercules.svg?" />
</p>

Hercules is an fast and highly customizable Git repository analysis engine
written in Go, built and open-sourced by [source{d}](https://sourced.tech/). It
runs a highly customizable pipeline of analysis tasks on a Git repository to
generate all sorts of cool data and insights. I am currently using Hercules as a
library for a project I am working on, so I've contributed a few fixes and
features upstream!

<p align="center">
    <img src="https://github.com/src-d/hercules/raw/master/doc/emberjs_people.png" width="100%" />
</p>

My contributions include:

- **new features** such as [reworked interval options](https://github.com/src-d/hercules/pull/245)
- **fixes** for a [race condition](https://github.com/src-d/hercules/pull/232) I
  I discovered, and a small fix to [improve `go mod` support](https://github.com/src-d/hercules/pull/230)

Check out my pull requests in more detail [here](https://github.com/src-d/hercules/pulls?q=is%3Apr+author%3Abobheadxi+is%3Aclosed)!
<br />