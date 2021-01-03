---
title: "Labelist: Serverless Function for Premium-Free Todoist Labels"
layout: post
description: a quick experiment with serverless functions and the Todoist API
image: 
headerImage: false
tag:
- hack
- api
- javascript
- serverless
category: blog
author: robert
description: 
---

This didn't really feel like enough of a project to warrant a project post, and
I want to embark on more small-scale "hack" projects in my spare time (now that
I've retired from [Launch Pad](https://bobheadxi.dev/tags/#launch-pad) for the
time being.

Anyway, I read about the [Bullet Journal (or BoJo for short)](https://bulletjournal.com/)
recently. It's more or less an analogue life journalling/task-management flow.
I don't really trust myself to write and read and not lose a notebook (though
I do have a bunch of cute small notebooks I could use for this purpose), so I
decided to have a think about how I could automate some parts of this.

For task management I currently use [Todoist](https://todoist.com), which has
pretty robust natural language parsing that I love (for example, to create a task
in my MATH341 class due tomorrow I would write `#math341 tomorrow 7pm something is due`,
and it would automatically pop the into the task into the appropriate project
with the correct due date). It also has nice apps for every platform out there.
It also has a pretty nice [developer API](https://developer.todoist.com/sync/v8/),
which is the main thing stopping me from switching to another Todo service.

A big part of BoJo is writing down *everything* - tasks, events, inspirations,
and whatnot. A pretty good way to do that would be with
[Todoist Labels](https://get.todoist.help/hc/en-us/articles/205195042-Labels)...
which is behind a paywall. Ugh.

Well, I noticed in [somebody's Todoist extension project](https://kanban.ist)
that they were able to create labels and manage them for me, so it *looked* like
the paywall was not enforced by the Todoist API. I gave it a shot:

```sh
curl "https://api.todoist.com/rest/v1/tasks/1234" \
  -X POST \
  --data '{"labels": [2345,5678]}' \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKKEn"
```

...and sure enough, it worked!

So I whipped up [a simple serverless function (dubbed Labelist)](https://github.com/bobheadxi/labelist)
to accept webhooks for task updates from Todoist, parse out `@___` labels (e.g. `@event`)
from the content, and add the labels by API instead. So when I create an event
and Todoist stubbornly refuses to add the label for me:

<p align="center">
  <img src="https://github.com/bobheadxi/labelist/raw/master/.static/example_before.png">
</p>

I just have to wait a few seconds, and Labelist will automatically add the label
for me:

<p align="center">
  <img src="https://github.com/bobheadxi/labelist/raw/master/.static/example_after.png">
</p>

I'm thinking this will help me out if I pursue this further and decide to build
out a reporting/reflection service for giving me a better idea of how I'm
managing my time and goals.

Head over to the [repository](https://github.com/bobheadxi/labelist) for more
details!
