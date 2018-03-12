---
title: "Sleuthing the Web"
layout: post
date: 2018-03-11 12:00
image: /assets/images/posts/squirrel.png
headerImage: true
tag:
- python
- solr
- scrapy
- rant
star: true
category: blog
author: robert
description: building a bad search engine
---

>*We're all basically building castles in the sand. Whether the surf comes in tomorrow, next year or next decade, don't kid yourself of its permanence. We're crafting art for the moment, and tomorrow's programmers will create new art for tomorrow's needs. The questions include:*
> - *did you do it well?*
>
> - *did you learn something from the experience?*
>
> - *did you give something back to the community, leave some breadcrumb, which will help the next guy, help advance civilization however little up to the next ladder rung?*
>
> - *was it beautiful? To you, to anyone?*
>
> *If any of all of those are true, look yea to Ozymandias... and be at peace.*

<p align="center">
    <a href="https://www.instagram.com/p/BfcZBYQh81m/?taken-by=savethefade">
        <img src="https://78.media.tumblr.com/219fabe10c6324db5fd05b06e32f8c3f/tumblr_p55eshoJcU1rg86u5o1_1280.jpg" width="60%" />
    </a>
</p>

<p align="center">
    <i>I met a traveller from an antique land...</i>
</p>

That quote there came from a Redditor in response to [a post about code at startups that never make it](https://www.reddit.com/r/cscareerquestions/comments/80073a/do_you_find_it_disturbing_that_all_that_code_all/dus0bob/), and how all the hard work that goes into a startup ends up thrown away and forgotten. I think that it issue is pretty relevant for anyone in software - especially when we first start out - since most of our work will inevitably end up discarded, whether they be personal projects, or homework, or internships.

Skip over to the [Prelude](#prelude) if you don't want to read any of this.

Anyway - typically, I am told to focus on the learning or experience aspect, and how projects and work look good on a resume. "Everything is good experience for you", they say. "Employers will love it."

It feels a little sobering to see how seriously some people take that sentiment. Maybe it's someone asking what language they should learn to improve their job prospects, or someone wondering if they can learn machine learning over a few weeks for their first personal project, or slowly realising that someone joined UBC Launch Pad with seemingly no real intention of putting in any effort. Maybe it's someone telling me that once he hands a project his club has been working on back to a charity, he doesn't care anymore, and that he has no intention of helping them deploy the project or advising them on how best to maintain it going forward.

There is nothing inherently wrong with all these things. It's okay to be strategic about what you learn. It's okay to be interested in an advanced subject. It's okay to not care. It's okay to seek motivation in competitive environments that also offer great networking opportunities.

It's just that I have always, perhaps naively, felt that there's a bit more to writing software than just a means to an end. There's something rather beautiful about how I learn more things to learn the more I learn, and the decisions that have to be made sometimes - simplicity versus flexibility, speed of progress versus tests and stability, clarity versus conciseness (is that a word?)... it goes on and on, and I'm sure more experienced folks will have far more to say.

Articles like the fantastic ["What is Code?"](https://www.bloomberg.com/graphics/2015-paul-ford-what-is-code/) by Paul Ford over at Bloomberg offers a really neat and rather informative (for me, at least) insight into the great (and not-so-great) aspects of software as a tool, science, and industry. A brief excerpt from that post about the efforts that go into software that makes software development more accessible:

> Apple and Microsoft, Amazon and Google: factory factories. Their APIs are the products of many thousands of hours of labor from many programmers. Think of the work involved. Someone needs to manage the SDK. Hundreds of programmers need to write the code for it. People need to write the documentation and organize the demos. Someone needs to fight for a feature to get funded and finished. Someone needs to make sure the translation into German is completed and that there aren’t any embarrassing mistakes that go viral on Twitter. Someone needs to actually write the software that goes into making the IDE work.

The article is a very lengthy read, but well worth it.

Seeing fantastic open source projects, where people spend seemingly hundreds of hundreds of hours building on a truly useful tool to give away for free, never ceases to amaze me. The example that comes to mind right now is [pg-promise](https://github.com/vitaly-t/pg-promise/graphs/contributors), a truly awesome, fantastic, comprehensive and well-documented PostgreSQL library written pretty much entirely by one person. It's a tool I've been using every day at work. I've been slowly reading the author's documentation and posts and every few days I find some new neat detail or trick that makes my life a bit easier.

I love watching a codebase grow and shrink and change over time. I love the feeling of putting together things that work, no matter how small or pointless. I love sitting back after a few months and looking at a project and thinking, wow, this is kind of bad and not really all that complex or impressive... but I'm a bit proud of it, because I think I put my heart in it, and it's nice to have something to work for and believe in. I had felt pretty lost about what I wanted to do with my life before I found this. Not that I don't feel lost anymore, but at least there's some sense of where to look now.

So when people ask, I try to help, try my best to teach what little I know, and try my best to make things easier. For [Inertia](https://github.com/ubclaunchpad/inertia), I spent many hours building a [comprehensive set of](/dockerception#ssh-services-in-docker) [tools and utilities](https://github.com/ubclaunchpad/inertia#testing) to make testing and seeing if your changes work a breeze, and I wrote [documentation](https://github.com/ubclaunchpad/inertia#how-it-works) about [how the project works](https://github.com/ubclaunchpad/inertia/blob/master/.static/inertia-v0-0-2-slides.pdf), and spent a lot of time explaining why things were built the way they are... even if no one on my team has been motivated enough to really use anything I set up yet. For [calories](https://github.com/bobheadxi/calories), a project I set up for my friends so they could have something on their resumes, I spent quite a few evenings and weekends walking through how to do things and writing extensive code reviews and teaching what I had learned, and for a while we made good progress. I ended up spending a lot of time writing and troubleshooting [a bunch of scripts](https://github.com/bobheadxi/calories#development) that would help install things and set up local interactive testing environments... which no one ended up using as development stopped. I set up a bunch of similar tools at work too... which no one has really used yet, since I'm the only full-time developer on the team.

Oh well! Learned a lot and I tried my best to help. I think. I hope. I suppose what I'm trying to say is, don't treat these things like a chore. There's something nice and beautiful in everything, even writing thousands of lines of code that just makes a few things happen on screen or adds some numbers, and we can all try to put a bit of love in what we do.

>*We're all basically building castles in the sand. Whether the surf comes in tomorrow, next year or next decade, don't kid yourself of its permanence. We're crafting art for the moment, and tomorrow's programmers will create new art for tomorrow's needs. The questions include:*
> - *did you do it well?*
>
> - *did you learn something from the experience?*
>
> - *did you give something back to the community, leave some breadcrumb, which will help the next guy, help advance civilization however little up to the next ladder rung?*
>
> - *was it beautiful? To you, to anyone?*
>
> *If any of all of those are true, look yea to Ozymandias... and be at peace.*

# Prelude

I found [UBC Launch Pad](http://www.ubclaunchpad.com) by chance over the summer after my first year at UBC. It seemed really exciting and I applied straight away, churning out the [application pre-task](https://github.com/bobheadxi/Android-Weather) overnight. At the time I was still working on [my first personal project](/facebook-spotify-bot) and the [r/Android App Store](/r-android-appstore), and I was not feeling at all confident. I was pretty certain I wouldn't hear back.

But I did, and it turned out to be one of the best decisions I had made in a very long time.

My first project at UBC Launch Pad was [Sleuth](/sleuth). The goal of Sleuth changed quite a bit over the course of the semester but at its core we wanted it to be a search engine, geared towards UBC-related content.

The team started out as a five-person team, but ended up being just two people, including myself, which complicated plans a bit. The bulk of our effort ended up going into our content and search components, and the front end was a bit of a tacked-on interface to demo our main "feature": linked results.

<p align="center">
    <img src="/assets/images/projects/sleuth-1.png" />
</p>

I think it was pretty neat. Built mostly by team member [Bruno](https://github.com/bfbachmann), the front end was pretty clean and featured cute draggable nodes.

# Crawling and Scraping the Web

WIP

# Search and Apache Solr

WIP

# The Sleuth Application Program Interface

WIP
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTYxMDIyMzg5N119
-->