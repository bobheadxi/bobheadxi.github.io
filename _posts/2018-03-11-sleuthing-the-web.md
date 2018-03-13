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

["What is Code?"](https://www.bloomberg.com/graphics/2015-paul-ford-what-is-code/) by Paul Ford over at Bloomberg  is a great article that offers a really neat and informative (for me, at least) insight into the great (and not-so-great) aspects of software as a tool, science, and industry. It's is a very lengthy read, but well worth it. I particularly like how he emphasises the sheer amount of work that goes into everything:

> Apple and Microsoft, Amazon and Google: factory factories. Their APIs are the products of many thousands of hours of labor from many programmers. Think of the work involved. Someone needs to manage the SDK. Hundreds of programmers need to write the code for it. People need to write the documentation and organize the demos. Someone needs to fight for a feature to get funded and finished. Someone needs to make sure the translation into German is completed and that there aren’t any embarrassing mistakes that go viral on Twitter. Someone needs to actually write the software that goes into making the IDE work.

Think about it! This doesn't just apply to software, but most things - there always seems to be far more work and effort than first meets the eye.

That's why seeing fantastic open source projects, where people spend seemingly hundreds of hundreds of hours building on a truly useful tool to give away for free, never ceases to amaze me. An example that comes to mind right now is [pg-promise](https://github.com/vitaly-t/pg-promise/graphs/contributors), a truly awesome, fantastic, comprehensive and well-documented PostgreSQL library written pretty much entirely by one person. It's a tool use every day at work. I have been slowly reading the author's documentation and articles and every few days, I find some new neat detail or trick in the library that helps me out. I think the library is partly sponsored, but it still really does feel like a work of love.

Typically, we are told to just focus on getting experience and projects on paper for resumes and portfolios. "Everything is good experience for you", they say. "Employers will love it". And I know a lot of people who think this way, who see writing software as a means to an end, or something they just have to do.

It's a bit beautiful, though - even writing thousands of lines of code that promptly gets forgotten. Programming, work, building personal projects... it's not necessarily just good experience for jobs or portfolios, but an awesome, creative, learning process that leverages the hard work of countless people before us to craft something special. Even if the idea isn't particularly unique, your implementation probably is, because it is yours.

At the end of the day, we're all just castles in the sand, and everything we do is rather meaningless in the grand scheme of the universe. We can choose, however, to put some heart in the things we do, no matter what it is - and that is what makes all the difference.

:smile:

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

We didn't have the search presence of Google leverage when asking people to conform to our crawler's expectations, so I focused on defining a number of categories. On the top level, I set up two crawlers: a `broad_crawler` that would generically traverse the links in its source pages, and a `custom_crawler` that would take a custom parser module to handle crawling. A crawler is essentially a bot that would visit and retrieve data from sites. These crawlers would then identify and pass web pages to the appropriate `parsers`. The data flow looks a bit like this:

<div class="mermaid" align="center">
graph TB;
    w(predefined seed URLs)==>s;
    w==>t;
    s(generic URLs)==visited by==>broad_crawler;
    t(targeted URLs)==visited by==>custom_crawler;
    broad_crawler==>p{process request};
    p==>type_1_parser;
    p==>type_2_parser;
    custom_crawler==>c[custom callbacks];
    c-.child links.->t;
    type_1_parser-.child links.->s;
    type_2_parser-.child links.->s;
    type_1_parser==>pipeline;
    type_2_parser==>pipeline;
    c==>pipeline;
    pipeline==>database;
</div>

This section will cover everything except the Pipeline and Database, which I will explain later.

### Parsers

I placed different parsers for different page types in a folder together in `/scraper/spiders/parsers` ([source](https://github.com/ubclaunchpad/sleuth/tree/master/sleuth_crawler/scraper/scraper/spiders/parsers)). I relied heavily on [xpath](https://en.wikipedia.org/wiki/XPath) to query for elements I wanted.

We also set up a few "datatypes" that would represent our web pages and what kind of data we wanted to retrieve:

```py
class ScrapyGenericPage(scrapy.Item):
    '''
    Stores generic page data and url
    '''
    url = scrapy.Field()
    title = scrapy.Field()
    site_title = scrapy.Field()
    description = scrapy.Field()
    raw_content = scrapy.Field()
    links = scrapy.Field()
```

There are a wide variety of tags to rely on for most pages. For our "generic" pages, I didn't need to get too in depth - some simple descriptive metadata would be sufficient.

```py
def parse_generic_item(response, links):
    '''
    Scrape generic page
    '''
    title = utils.extract_element(response.xpath("//title/text()"), 0).strip()
    titles = re.split(r'\| | - ', title)

    # Use OpenGraph title data if available
    if len(response.xpath('//meta[@property="og:site_name"]')) > 0 and \
        len(response.xpath('//meta[@property="og:title"]')) > 0:
        title = utils.extract_element(
            response.xpath('//meta[@property="og:title"]/@content'), 0
        )
        site_title = utils.extract_element(
            response.xpath('//meta[@property="og:site_name"]/@content'), 0
        )
    elif len(titles) >= 2:
        title = titles[0].strip()
        site_titles = []
        for i in range(max(1, len(titles)-2), len(titles)):
            site_titles.append(titles[i].strip())
        site_title = ' - '.join(site_titles)
    else:
        site_title = ''

    # Use OpenGraph description if available
    if len(response.xpath('//meta[@property="og:description"]')) > 0:
        desc = utils.extract_element(
            response.xpath('//meta[@property="og:description"]/@content'), 0
        )
    else:
        desc = utils.extract_element(
            response.xpath('//meta[@name="description"]/@content'), 0
        )

    raw_content = utils.strip_content(response.body)

    return ScrapyGenericPage(
        url=response.url,
        title=title,
        site_title=site_title,
        description=desc,
        raw_content=raw_content,
        links=links
    )
```

For more specific types I could get a bit more in-depth. For example, for Reddit posts, I could make post parsing dependent on karma, and retrieve comments above a certain karma threshold as well.

```py
def parse_post(response, links):
    '''
    Parses a reddit post's comment section
    '''

    post_section = response.xpath('//*[@id="siteTable"]')

    # check karma and discard if below post threshold
    karma = utils.extract_element(
        post_section.xpath('//div/div/div[@class="score unvoted"]/text()'), 0
    )
    if karma == "" or int(karma) < POST_KARMA_THRESHOLD:
        return

    # get post content
    post_content = utils.extract_element(
        post_section.xpath('//div/div[@class="entry unvoted"]/div/form/div/div'), 0
    )
    post_content = utils.strip_content(post_content)

    # get post title
    titles = utils.extract_element(response.xpath('//title/text()'), 0)
    titles = titles.rsplit(':', 1)
    title = titles[0].strip()
    subreddit = titles[1].strip()

    # get comments
    comments = []
    comment_section = response.xpath('/html/body/div[4]/div[2]')
    comment_section = comment_section.xpath('//div/div[@class="entry unvoted"]/form/div/div')
    for comment in comment_section:
        comment = utils.strip_content(comment.extract())
        if len(comment) > 0:
            comments.append(' '.join(c for c in comment))

    return ScrapyRedditPost(
        url=response.url,
        title=title,
        subreddit=subreddit,
        post_content=post_content,
        comments=comments,
        links=links
    )
```

### The Crawlers

I made this distinction between a `broad_crawler` and a `custom_crawler` because UBC course data had to be crawled in a very specific manner from the UBC course site, and we wanted to be able to retrieve very specific information (such as rows of tables on the page for course section data). The idea was that `custom_crawler` would be an easily extendable module that could be used to target specific sites. Because of this, the `course_crawler` itself was pretty simple:

```py
import scrapy
from scrapy.spiders import Spider

class CustomCrawler(Spider):
    '''
    Spider that crawls specific domains for specific item types
    that don't link to genericItem
    '''
    name = 'custom_crawler'

    def __init__(self, start_urls, parser):
        '''
        Takes a list of starting urls and a callback for each link visited
        '''
        self.start_urls = start_urls
        self.parse = parser
```

To start it up, I would attach the appropriate parsing module to the crawler and let it run free:

```py
process.crawl('custom_crawler', start_urls=CUSTOM_URLS['courseItem'], parser=parse_subjects)
```

The `broad_crawler` is where the modularised `parser` design really shined, I think, allowing me to dynamically assign parsers after processing each request. I also set up some very rudimentary filtering when retrieving a page's links.

```py
class BroadCrawler(CrawlSpider):
    '''
    Spider that broad crawls starting at list of predefined URLs
    '''
    name = 'broad_crawler'

    # These are the links that the crawler starts crawling at
    start_urls = PARENT_URLS

    # Rules for what links are followed are defined here
    allowed_terms = [r'(ubc)', r'(university)', r'(ubyssey)', r'(prof)', r'(student)', r'(faculty)']
    denied_terms = [r'(accounts\.google)', r'(intent)', r'(lang=)']
    GENERIC_LINK_EXTRACTOR = LinkExtractor(allow=allowed_terms, deny=denied_terms)

    rules = (
        Rule(
            GENERIC_LINK_EXTRACTOR,
            follow=True, process_request='process_request',
            callback='parse_generic_item'
        ),
    )

    def process_request(self, req):
        '''
        Assigns best callback for each request
        '''
        if 'reddit.com' in req.url:
            req = req.replace(priority=100)
            if 'comments' in req.url:
                req = req.replace(callback=self.parse_reddit_post)
            else:
                req = req.replace(callback=self.no_parse)

        return req
```

## Search and Apache Solr

WIP

## The Sleuth Application Program Interface

WIP
