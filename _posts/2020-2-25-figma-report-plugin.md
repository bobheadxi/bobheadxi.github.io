---
title: "Generating Reports in Figma with a Custom Figma Plugin"
layout: post
date: 2020-2-25 9:00
image: https://upload.wikimedia.org/wikipedia/commons/3/33/Figma-logo.svg
headerImage: true
tag:
- automation
- typescript
- figma
- sumus
category: blog
author: robert
tech_writeup: false # TODO: set to true when done
description: Building a Figma Plugin for generating reports in Figma from various data sources
---

<p align="center">
  <b>
    :warning: This post is a work in progress!
  </b>
</p>

My second chunk of work for my [part-time remote position at Sumus](/sumus) (read about
[the first chunk here](/appengine-branch-previews)) involved building a Figma plugin to generate
a property pitch report from data about a property collected by employees, mostly aggregated on a
central [Wordpress](https://wordpress.com/) instance. For the unfamiliar, [Figma](https://www.figma.com/)
is a neat web-based tool for collaborative design, featuring a very robust set of APIs, which made
choosing it for automating the property pitch report process a pretty obvious one.

In this post I'll write about approaching the Figma plugin API and leveraging it to automate aggregating
data from various sources to generate a baseline report that can easily be customized further!

- [Requirements](#requirements)
- [Implementation](#implementation)
  - [Figma Plugins Rundown](#figma-plugins-rundown)
  - [Collecting Input and using React as our iframe](#collecting-input-and-using-react-as-our-iframe)
  - [Manipulating Figma Nodes and Working with the FigmaSandbox](#manipulating-figma-nodes-and-working-with-the-figmasandbox)
  - [Other Considerations](#other-considerations)

## Requirements

This plugin would have to be able to:

* retrieve basic data collected by employees from our Wordpress instance
* download images, generate maps, and retrieve miscellaneous assets from various sources to augment the report
* splat all this data onto a Figma document in an attractive, organized manner

As far as implementation goes, this posed a few problems when using Figma Plugins - read on for more
details!

## Implementation

### Figma Plugins Rundown

To start off I am going to give a quick overview of how Figma Plugins work. This is also covered in
["How Plugins Run"](https://www.figma.com/plugin-docs/how-plugins-run/) from the official documentation,
but for some reason it still took me quite a while to figure things out, so I'll explain it slightly
differently here:

```mermaid
sequenceDiagram
  participant FigmaSandbox
  note left of FigmaSandbox: for interactions \nwith Figma API \n(reading layers, \nmanipulating nodes, \netc.)

  participant iframe
  note right of iframe: for interactions \nwith browser APIs \n(user input, \nnetwork access, \netc.)

  FigmaSandbox->>iframe: { type: someMessageType, ...props }
  note over FigmaSandbox,iframe: sent by window.parent.postMessage, \nreceived by figma.ui.onmessage

  iframe->>FigmaSandbox: { pluginMessage: { type: someMessageType, ...props } }
  note over iframe,FigmaSandbox: sent by figma.ui.postMessage, \nreceived by window.onmessage
```

Sometimes the `FigmaSandbox` is referred to as the "main thread", and the `iframe` is also called a "worker".
The "why" of this setup is explained in the official documentation:

> For performance, we have decided to go with an execution model where plugin code runs on the main
> thread in a sandbox. The sandbox is a minimal JavaScript environment and does not expose browser APIs.

That means that you'll have two components to your plugin: a user interface that has code that runs
in the `iframe`, which *also* handles any browser API usage (any network requests, the DOM, and so on),
while any code that does the actual work of handling interactions with Figma (reading layers,
manipulating nodes, setting views, and so on) runs in an entirely separate `FigmaSandbox`. The only
way these two can communicate is through *message passing* via the Figma plugin framework, as described
in the above diagram.

This means that to build this thing, we'd either have to:

* front-load everything in the `iframe` before passing everything onto the `FigmaSandbox` - this would
  require knowing all such dependencies beforehand, and passing a lot of information around
* do some ping-ponging between the `iframe` and `FigmaSandbox`, where each page we generate can declare
  its own dependencies and fetch them appropriately

We ended up going with the second option, which lended itself to a more compartmentalized approach,
as outlined below:

```mermaid
sequenceDiagram
  participant External
  note over External: your sources of data

  participant iframe
  activate iframe

  participant FigmaSandbox
  iframe->>FigmaSandbox: generate_report
  deactivate iframe
  activate FigmaSandbox
  note over iframe,FigmaSandbox: communicate over Figma messages

  loop for each template in pages
    FigmaSandbox->>FigmaSandbox: init_page_frame

    alt if template.assets?
      FigmaSandbox->>iframe: fetch_assets
      activate iframe
      iframe->>External: request
      note over iframe,External: via browser fetch API
      External-->>iframe: data
      iframe-->>FigmaSandbox: loaded_assets
      deactivate iframe
      FigmaSandbox->>FigmaSandbox: template(FrameNode, assets)
    else
      FigmaSandbox->>FigmaSandbox: template(FrameNode)
    end
  end
  deactivate FigmaSandbox
```

### Collecting Input and using React as our iframe

TODO

### Manipulating Figma Nodes and Working with the FigmaSandbox

TODO

### Other Considerations

TODO
