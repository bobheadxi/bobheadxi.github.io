---
title: "Branch Previews with Google App Engine and GitHub Actions"
layout: post
date: 2019-11-08 11:00
image:
headerImage: true
tag:
- hack
- gcp
- automation
- devops
category: blog
author: robert
description: Leveraging GitHub Actions for easy-to-use, automated branch preview deployments
---

<p align="center">
    <i>This post is a work in progress - will finish soon!</i>
</p>

<br />

Shortly after I returned to school, early in October 2019 I started
[working part-time remotely for Sumus](/sumus), a property management company
based out of Lethbridge, Alberta. My role was primarily as a software developer
on a investor portal they wanted to build. I wasn't starting from scratch - there
was already a sizable codebase going, and a simple deployment set up on
[Google App Engine](https://cloud.google.com/appengine/).

Right off the bat I had a number of tech-debt-related issues I wanted to address
before I started developing new features, one of which was automating this
deployment process. As I progressed on the automation of the App Engine deployment,
I realized branch previews were not that much more of a hassle to set up, so I got
those up and running as well. This blog post will cover some of the work I did
on this front, and hopefully give a good idea about how you can go about creating
a similar setup for your own projects if you want. Our project consists of a
React frontend serviced by a Node.js backend, so my post will lean a bit towards
that particular setup.

* [The Problem](#the-problem)
* [Solution](#solution)
  * [Staging and Release](#staging-and-release)
  * [Versioning Frontends and Backends](#versioning-frontends-and-backends)
  * [Automation](#automation)
* [Wrapup](#wrapup)

<br />

## The Problem

First off, a quick intro to App Engine. This was my first encounter with App Engine,
so this won't be the best rundown, but in a nutshell App Engine seems like a
reasonably priced way to deploy your application in a serverless fashion with
the flexibility to scale to your needs. It also offers nice out-of-the-box
integration with Google's other monitoring offerings, which is a nice plus.

Most of the official documentation seems to indicate that deployment happens
primarily through:

* defining an application specification, the [`app.yaml`](https://cloud.google.com/appengine/docs/standard/python/config/appref)
* using the [`gcloud` CLI](https://cloud.google.com/sdk/gcloud/) to push a deployment out from your copy of the codebase

The old process for deploying our application involved making sure I had all
my credentials and stuff set up, and running:

```sh
gcloud app deploy app.yaml
```

There was no real way short of making sure I wasn't axing someone else's
deployment or notifying everyone of what is currently active short of shooting
a Slack announcement and hoping it's seen and handled appropriately. I felt like
the entire process would be more comfortable if it was automated and tied to
source control, so that:

* permissions are easier to manage
* it's easy to tell what is deployed
* less work to continuously update deployments

## Solution

I didn't actually start off with leveraging GitHub Actions for automating this
process - my first iteration used [CircleCI](https://circleci.com/), where we
run out tests and style checkks and whatnot, which had the advantage of allowing
me to stage deployments based on whether or not previous checks pass:

<p align="center">
  <img src="/assets/images/posts/appengine/pipeline.png">
</p>

Unfortunately this was eating up a huge chunk of our pipeline minutes - as you
can see in the image above, the `appengine_stage` job takes more than 97% of
each build when a branch is configured to stage. This brought us uncomfortably
close to hitting the [CircleCI free tier](https://circleci.com/pricing/), so
I ended up moving it to GitHub Actions to split up our workloads.

### Staging and Release

I first ran into the concept of branch previews working on the [UBC Launch Pad website](/ubclaunchpad-site),
where we leveraged [Netlify's](https://www.netlify.com/) great branch preview feature.
It was a fantastic way to do some live testing and get feedback quickly, so I leveraged
branch previews again during my time with [nwPlus working on the nwHacks 2019 website](/nwhacks2019),
where I used a tool I worked on, [`ubclaunchpad/inertia`](https://github.com/ubclaunchpad/inertia),
to quickly stage previews for the nwPlus design team to provide feedback on.

Now that I'm back to working on websites, I figured branch previews would come
in useful here again (and they have so far!). To accomodate this, I introduced
some extra steps to our deployment flow:

* *Staging* deployments are primarily for previewing branches. By default,
  the only staged branch would be `master`, but additional branches can be staged
  by adding the desired branch to the GitHub Action configuration. These deployments
  are named based on their branch, i.e. `stage-master` or `stage-my-branch`.
* *Release* deployments are for deploying tags. These deployments are [promoted](https://cloud.google.com/sdk/gcloud/reference/app/deploy#--promote)
  (unlike the staging deployments) such that all traffic to the application route
  to the most recent release deployment by default. These are named based on
  their tag, i.e. `release-v0-3-0`.

### Versioning Frontends and Backends

TODO

### Automation

TODO

## Wrapup

TODO
