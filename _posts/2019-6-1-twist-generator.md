---
title: ":satellite: Canonical Imports Generator for Go Packages"
layout: post
date: 2019-06-01 12:19
tag:
- golang
- cli
- generator
image: ""
headerImage: false
open_source: true
hidden: true # don't count this post in blog pagination
description: "<i>twist</i> - static and serverless canonical imports for your Go packages"
category: open-source
author: robert
star: false
externalLink: false
badges: []
---

<p align="center">
  <a href="https://github.com/bobheadxi/twist">    
    <img src="https://img.shields.io/badge/github-twist-blye.svg?style=for-the-badge" alt="GitHub Repository"/>
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/bobheadxi/twist.svg" />
  <img src="https://goreportcard.com/badge/go.bobheadxi.dev/twist" />
</p>

Twist generates canonical imports for your Go packages. Since it does not require
a running server (ie in existing tools like [uber-go/sally](https://github.com/uber-go/sally)
and [rsc/go-import-redirector](https://github.com/rsc/go-import-redirector)),
Twist is particularly useful in conjunction with [GitHub Pages](https://pages.github.com/).

A canonical import path allows you to make your package import a little fancier
with a custom domain, for example:

```diff
- import "github.com/bobheadxi/zapx"
+ import "go.bobheadxi.dev/zapx"
```

I use Twist myself to generate import names for my packages at [go.bobheadxi.dev](https://github.com/bobheadxi/go),
which acts as the source for a GitHub Pages site that performs the redirection.

The CLI can easily generate templates for a single package:

```sh
go get -u go.bobheadxi.dev/twist
#          [        source         ] [     canonical     ]
twist -o x github.com/bobheadxi/zapx go.bobheadxi.dev/zapx
```

Or generate templates for many packages using a flexible configuration format:

```sh
twist -c twist.example.yml -o x -readme
```

Drop by the [repository](https://github.com/bobheadxi/twist) to learn more!

<br />
