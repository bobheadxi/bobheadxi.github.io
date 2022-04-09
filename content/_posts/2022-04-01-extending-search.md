---
title: "Extending Sourcegraph search"
layout: post
image: https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/google/313/magnifying-glass-tilted-right_1f50e.png
hero_image: /assets/images/posts/extending-search/block-search.png
headerImage: true
maths: false
featured: true
diagrams: true
tag:
- hackathon
- experiment
- golang
- search
- postgres
- sourcegraph
category: blog
author: robert
description: adding new search types to Sourcegraph in a brief hackathon project
---

Last week, [Sourcegraph](../_experience/2021-7-5-sourcegraph.md) held a brief internal hackathon where we got to work on a variety of ideas related to our [freshly minted "Sourcegraph use cases"](https://about.sourcegraph.com/use-cases). One idea that was raised was extending Sourcegraph's [core code search functionality](https://about.sourcegraph.com/code-search) to allow queries over [search notebooks](https://docs.sourcegraph.com/notebooks), a new product that enables live and persistent documentation based on code search.

![notebooks demo](https://storage.googleapis.com/sourcegraph-assets/docs/images/notebooks/notebooks_home.gif)

We would want to be able to do the following within the search language:

```none
type:notebook my notebook query
```

And render search notebooks within search results! The language also supports operators like `select:repo` today, so we set out to implement something similar for our MVP as well.

For some context, this is what code search results usually look like:

![search page](https://about.sourcegraph.com/screenshots/search-page-single-image.png)

Note that all the code internals mentioned in this post may change - you can view the Sourcegraph repository at [`73a484e`](https://sourcegraph.com/github.com/sourcegraph/sourcegraph@73a484e) for a accurate picture of what the codebase looked like at the time!

## Introducing a search job

Jobs are structured behind a [`Job` interface](https://sourcegraph.com/github.com/sourcegraph/sourcegraph@73a484e/-/blob/internal/search/job/types.go?L23:6#tab=references):

```go
// Job is an interface shared by all individual search operations in the
// backend (e.g., text vs commit vs symbol search are represented as different
// jobs) as well as combinations over those searches (run a set in parallel,
// timeout). Calling Run on a job object runs a search.
type Job interface {
	Run(context.Context, database.DB, streaming.Sender) (*search.Alert, error)
	Name() string
}
```

The typical example here a search that calls out to our [Zoekt backend](https://github.com/sourcegraph/zoekt). A `Job` could also combine multiple search jobs, such as to [run some in parallel](https://sourcegraph.com/github.com/sourcegraph/sourcegraph@73a484e/-/blob/internal/search/job/combinators.go?L86:6) or to [prioritize results from certain jobs before others](https://sourcegraph.com/github.com/sourcegraph/sourcegraph@73a484e/-/blob/internal/search/job/combinators.go?L19:6).

For example, a typical query `foobar` will evaluate to something like this, calling out to a variety of search backends (`ZoektGlobalSearch`, `RepoSearch`, `ComputeExcludedRepos`) within certain limits, imposed by jobs for enforcing those limits.

```mermaid
flowchart TB
0([TIMEOUT])
  0---1
  1[20s]
  0---2
  2([LIMIT])
    2---3
    3[500]
    2---4
    4([PARALLEL])
      4---5
      5([ZoektGlobalSearch])
      4---6
      6([RepoSearch])
      4---7
      7([ComputeExcludedRepos])
```

The evaluated search job varies based on your search query - an exhaustive commit search (`foo type:commit count:all`) will create the following job instead, with a longer timeout and higher limit:

```mermaid
flowchart TB
0([TIMEOUT])
  0---1
  1[1m0s]
  0---2
  2([LIMIT])
    2---3
    3[99999999]
    2---4
    4([PARALLEL])
      4---5
      5([Commit])
      4---6
      6([ComputeExcludedRepos])
```

TODO implement the job

Nice! We can test evaluating the query `type:notebook select:notebook.block.md foobar` to see our new search job type being registered:

```mermaid
flowchart TB
0([TIMEOUT])
  0---1
  1[20s]
  0---2
  2([LIMIT])
    2---3
    3[500]
    2---4
    4([SELECT])
      4---5
      5[notebook.block.md]
      4---6
      6([PARALLEL])
        6---7
        7([NotebookSearch])
        6---8
        8([ComputeExcludedRepos])
```

In this case, the `select:` term is just thrown in to demonstrate that it's a job that occurs *on top* of a child job, which contains the `NotebookSearch` job we created. This will be important later.
