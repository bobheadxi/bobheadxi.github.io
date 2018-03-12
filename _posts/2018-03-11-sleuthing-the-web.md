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

That quote there came from a Redditor in response to [a post about code at startups that never make it](https://www.reddit.com/r/cscareerquestions/comments/80073a/do_you_find_it_disturbing_that_all_that_code_all/dus0bob/). The poster mentioned how all the hard work that goes into a startup ends up thrown away and forgotten, and I noticed that this is pretty relevant for anyone in software - especially when we first start out - since most of our work will inevitably end up discarded, whether they be personal projects, or homework, or things we write at work.

Typically, we are told not to worry about that, to just focus on the learning or experience aspect, and think about how projects and work look good on a resume. "Everything is good experience for you", they say. "Employers will love it."

It can be a little sobering to see how seriously some people take that sentiment. There's nothing particularly wrong with it, I suppose. It's just that I have always, perhaps naively, come to feel that there's a bit more to writing software than just a means to an end.

["What is Code?"](https://www.bloomberg.com/graphics/2015-paul-ford-what-is-code/) by Paul Ford over at Bloomberg  is a great article that offers a really neat and informative (for me, at least) insight into the great (and not-so-great) aspects of software as a tool, science, and industry. It's is a very lengthy read, but well worth it. Here's a brief excerpt from that post about the efforts that go into software that makes software development more accessible:

> Apple and Microsoft, Amazon and Google: factory factories. Their APIs are the products of many thousands of hours of labor from many programmers. Think of the work involved. Someone needs to manage the SDK. Hundreds of programmers need to write the code for it. People need to write the documentation and organize the demos. Someone needs to fight for a feature to get funded and finished. Someone needs to make sure the translation into German is completed and that there aren’t any embarrassing mistakes that go viral on Twitter. Someone needs to actually write the software that goes into making the IDE work.

Think about it! This doesn't just apply to software, but most things - there always seems to be far more work and effort than first meets the eye.

That's why seeing fantastic open source projects, where people spend seemingly hundreds of hundreds of hours building on a truly useful tool to give away for free, never ceases to amaze me. An example that comes to mind right now is [pg-promise](https://github.com/vitaly-t/pg-promise/graphs/contributors), a truly awesome, fantastic, comprehensive and well-documented PostgreSQL library written pretty much entirely by one person. It's a tool use every day at work. I have been slowly reading the author's documentation and articles and every few days, I find some new neat detail or trick in the library that helps me out. I think the library is partly sponsored, but it still really does feel like a work of love.

I suppose what I'm trying to say is, we don't treat these things as just a chore and keys to jobs. There's something nice and beautiful and appreciable in everything - even writing thousands of lines of code that makes a few things happen on screen or adds some numbers. At the end of the day, our lives are just castles in the sand, and rather meaningless, unless we put some heart in what we do.

:)

# Prelude

I found [UBC Launch Pad](http://www.ubclaunchpad.com) by chance over the summer after my first year at UBC. It seemed really exciting and I applied straight away, churning out the [application pre-task](https://github.com/bobheadxi/Android-Weather) overnight. At the time I was still working on [my first personal project](/facebook-spotify-bot) and the [r/Android App Store](/r-android-appstore), and I was not feeling at all confident. I was pretty certain I wouldn't hear back.

But I did, and it turned out to be one of the best decisions I had made in a very long time.

My first project at UBC Launch Pad was [Sleuth](/sleuth). The goal of Sleuth changed quite a bit over the course of the semester but at its core we wanted it to be a search engine, geared towards UBC-related content.

The team started out as a five-person team, but ended up being just two people, including myself, which complicated plans a bit. The bulk of our effort ended up going into our content and search components, and the front end was a bit of a tacked-on interface to demo our main "feature": linked results.

<p align="center">
    <img src="/assets/images/projects/sleuth-1.png" />
</p>

I think it was pretty neat. Built mostly by team member [Bruno](https://github.com/bfbachmann), the front end is pretty clean, and featured cute, draggable nodes.

This post will briefly go over some of the more interesting parts of Sleuth, and how an amateur (me) approached building a search engine service.

# Sleuth

We set up Sleuth as a three-component project:

- Web: Sleuth's API endpoints, database connections, and crawler
- Solr: our Apache Solr instance
- Frontend: Sleuth's snazzy face

This post will mostly be about the Web component, with a bit about Solr.

## Crawling and Scraping the Web

Content curation is handled by the `sleuth_crawler` ([source](https://github.com/ubclaunchpad/sleuth/tree/master/sleuth_crawler)). The crawler is based on [scrapy](https://scrapy.org), a popular and flexible web scraping library for Python.

In theory, the scraper needed to:

- visit a page and visit each of its links
- retrieve relevant information
- store in our database

Turns out all this is far easier said than done. Since this wasn't just my first web scraping experience, but also my first Python experience, and everything was strange and confusing. I went through a huge number of strange and convoluted renditions of the scraper before I finally settled on a design.

It turns out there was no conceivable way to design a single crawler that would handle the seemingly infinite types of sites out there. Perhaps this is a bit obvious, but for a long time I was trying to come up with a "definition" that my crawler could rely on every website to have, and attempt to retrieve information that way. That did not work very well.

Fun fact - Google itself seems to cheat a bit on this by offering the [Google Search Console](https://www.google.com/webmasters/tools/dashboard)! Here you can request hits from the Google crawler and find out how to add "rich results" for your web page. You do this by using specific metadata tags that Google's crawler can look for and retrieve. Turns out Google's nice search result "cards" aren't as magical as I thought they were... although it is still very neat.

We didn't have the search presence of Google leverage when asking people to conform to our crawler's expectations, so I focused on defining a number of categories. On the top level, I set up two crawlers: a `broad_crawler` that would generically traverse the links in its source pages, and a `custom_crawler` that would take a custom parser module to handle crawling. A crawler is essentially a bot that would visit and retrieve data from sites. These crawlers would then identify and pass web pages to the appropriate `parsers`. The structure looks a bit like this:

WORK IN PROGRESS SORRY

<div class="mermaid">
graph LR;
    subgraph broad_crawler;
    any_site-->broad_crawler;
    any_site-->parser_1;
    any_site-->parser_2;
    any_site-->parser_3;
    end;
    parser_1 --> pipeline;
    parser_2 --> pipeline;
    parser_3 --> pipeline;
    subgraph custom_crawler;
    custom_crawler-->specific_site;
    specific_site-->specific_parser;
    end;
    specific_parser-->pipeline;
    pipeline-->database;
</div>

### custom_crawler

I made this distinction between a `broad_crawler` and a `custom_crawler` because UBC course data had to be crawled in a very specific manner from the UBC course site, and we wanted to be able to retrieve very specific information (such as rows of tables on the page for course section data). The idea was that `custom_crawler` would be an easily extendable module that could be used to target specific sites. Because of this, the `course_crawler` itself was pretty simple:

```python
import scrapy
from scrapy.spiders import Spider

class CustomCrawler(Spider):
    '''
    Spider that crawls specific domains for specific item types
    that don't link to genericItem
    '''
    name = 'custom_crawler'

    # Specifies the pipeline that handles data returned from the parsers
    custom_settings = {
        'ITEM_PIPELINES': {
            'scraper.pipelines.SolrPipeline': 400,
        }
    }

    def __init__(self, start_urls, parser):
        '''
        Takes a list of starting urls and a callback for each link visited
        '''
        self.start_urls = start_urls
        self.parse = parser
```

To start it up, I would attach the appropriate parsing module to the crawler:

```python
process.crawl('custom_crawler', start_urls=CUSTOM_URLS['courseItem'], parser=parse_subjects)
```

## Search and Apache Solr

WIP

## The Sleuth Application Program Interface

WIP
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5NDE5OTU3Ml19
-->