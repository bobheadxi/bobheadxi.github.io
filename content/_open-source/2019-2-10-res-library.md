---
title: ":mailbox: RESTful Primitives Library"
layout: post
tag:
- golang
- rest
- http
- library
image: ""
headerImage: false
description: "<i>res</i> - ergonomic primitives for working with JSON in Golang HTTP servers and clients"
author: robert
star: false
externalLink: false
badges: []
---

<p align="center">
    <a href="https://github.com/bobheadxi/res">
        <img src="https://img.shields.io/badge/github-res-red.svg?style=for-the-badge" alt="GitHub Repository"/>
    </a>
</p>

<p align="center">
  <a href="https://godoc.org/github.com/bobheadxi/res">
    <img src="https://godoc.org/github.com/bobheadxi/res?status.svg" alt="GoDoc">
  </a>
  <a href="https://dev.azure.com/bobheadxi/bobheadxi/_build/latest?definitionId=1&branchName=master">
    <img src="https://dev.azure.com/bobheadxi/bobheadxi/_apis/build/status/bobheadxi.res?branchName=master" alt="CI Status" />
  </a>
</p>

Package `res` provides handy primitives for working with JSON in Go HTTP servers
and clients via [`go-chi/render`](https://github.com/go-chi/render). It is
designed to be lightweight and easy to extend.

I originally wrote something similar to this in two
[UBC Launch Pad](https://www.ubclaunchpad.com/) projects that I worked on -
[Inertia](https://github.com/ubclaunchpad/inertia) and
[Pinpoint](https://github.com/ubclaunchpad/pinpoint) - and felt like it might
be useful to have it as a standalone package.

Here's a quick overview:

### Clientside

```go
import "github.com/bobheadxi/res"

func main() {
  resp, err := http.Get(os.Getenv("URL"))
  if err != nil {
    log.Fatal(err)
  }
  var info string
  b, err := res.Unmarshal(resp.Body, res.KV{Key: "info", Value: &info})
  if err != nil {
    log.Fatal(err)
  }
  if err := b.Error(); err != nil {
    log.Fatal(err)
  }
  println(info)
}
```

### Serverside

```go
import "github.com/bobheadxi/res"

func Handler(w http.ResponseWriter, r *http.Request) {
  res.R(w, r, res.MsgOK("hello world!",
    "stuff", "amazing",
    "details", res.M{"world": "hello"}))
}
```

<br />
