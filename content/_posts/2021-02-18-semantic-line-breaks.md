---
title: "Semantic Line Breaks"
layout: post
image: /assets/images/posts/semantic-line-breaks/enter.png
headerImage: true
diagrams: false
tag:
- automation
- docs
- experiment
- collaboration
category: blog
author: robert
description: making changes to documentation readable and understandable
---

As an organization grows, it becomes increasingly important to record knowledge and processes. One popular approach is using a collection of [Markdown](https://en.wikipedia.org/wiki/Markdown) files, tracked in Git, where changes can easily be proposed and discussed. Unfortunately, the readability and understandability of these changes is often quite poor, negating much of the benefits of using a version control system.

In general, Markdown files are written with lines breaks at some arbitrary character column (such as 80 characters), or are written with entire paragraphs on a single line.
Both these approaches have significant issues:

- Line-breaking at some arbitrary character column looks nice when viewed, but is easily lost when making and suggesting edits, necessitating reflowing entire paragraphs.
  This leads to incomprehensible or uninformative diffs that are difficult to review.
- Writing entire paragraphs on a single line is reasonably readable nowadays due to most editors and viewers performing wrapping out-of-the-box, but they make suggestions and diffs difficult to review due to every single change causing a diff on entire paragraphs.

To combat this, the idea of *semantic line breaks* has been floated. The general idea is to perform line breaks along semantic boundaries, instead of just along paragraphs. An approach suggested at [`sembr.org`](https://sembr.org/) sums this up as:

> When writing text with a compatible markup language, add a line break after each substantial unit of thought.

This particular specification goes on to describe how this works:

> Many lightweight markup languages, including Markdown, reStructuredText, and AsciiDoc, join consecutive lines with a space. Conventional markup languages like HTML and XML exhibit a similar behavior in particular contexts.
> This behavior allows line breaks to be used as semantic delimiters, making prose easier to author, edit, and read in source — without affecting the rendered output.
> [...]
> By inserting line breaks at semantic boundaries, writers, editors, and other collaborators can make source text easier to work with, without affecting how it’s seen by readers.

In my interpretation, a good semantic line break specification then ought to:

- Make use of how most Markdown specifications ignore single new lines to still provide a good **rendered Markdown** experience.
- Leverage modern line-wrapping in most viewers to maintain a good **raw Markdown** experience.
- Maintain understandable diffs in Markdown documentation for a good **reviewing** experience.

I quite like this idea! Consider the following text, where we want to change `incididunt` with `oh I am so hungry`:

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

If the text was broken at a character column, the resulting diff (including reflowing the text) might look like:

```diff
- Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
+ Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor oh I am
- ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation
+ so hungry ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
- ullamco laboris nisi ut aliquip ex ea commodo consequat.
+ exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
```

This can be rather incomprehensible. If the text was not broken at all, the diff would then look like:

```diff
- Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
+ Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor oh I am so hungry ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
```

This is marginally better, but still quite difficult, especially because not all git interfaces will be able to show you the specific word that has changed (and even fewer that can do that for very, very long lines).

Perhaps semantic line breaks could allow us to break this paragraph of text into smaller chunks, and make small diffs significantly more approachable, simpler to reason about, and easier to discuss.

## Solving unreadable changes

[`sembr.org`](https://sembr.org/) proposes a set of rules that would make content easier to manage and make changes to. Their website presents the following example:

> All human beings are born free and equal in dignity and rights. They are endowed with reason and conscience and should act towards one another in a spirit of brotherhood.

Their *recommendation* is to change this to:

```
All human beings are born free and equal in dignity and rights.
They are endowed with reason and conscience
and should act towards one another in a spirit of brotherhood.
```

*Recommendation* is the crux of the problem here, and is a significant drawback. The [`sembr.org`](https://sembr.org/) specification depends entirely on the writer to maintain the appropriate formatting, and it leaves the interpretation of what a "semantic boundary" is at all up in the air. *Nine* of the twelve requirements in this particular specification are `MAY`'s, `SHOULD`'s, and `RECOMMEND`'s! This is surely to lead to:

- Inconsistent and difficult documents, thanks to so much of the  specification being up for interpretation.
- Contributors forgetting to add, or simply not wanting to go through the trouble of adding, the necessary line breaks.
- *Someone* is going to be frustrated at someone else's very short lines, and refuse to format appropriately. Alternatively, they might disagree with someone else's line breaks, and cause unnecessary churn in diffs.

Both of these problems pose significant barriers to widespread adoption, which is necessary for any semantic line break specification to be of any use.

## A linter for semantic line breaks

A similar problem arises with code standards: semicolons? Spaces or tabs? Left up to individuals, no standard will ever be truly consistent, especially in the face of the need to "just get the job done". Code formatting, however, has been solved mostly through *automated* tooling. Why bother arguing about semicolons if a program will just do it for you, and will even check if everything is consistent?

What if the same thing could happen for documentation source: a tool to automatically format your text? To accommodate this, I propose a simpler specification that still offers a small amount of customization:

- A *semantic boundary* is defined to be the end of a sentence.
- Allow multiple short sentences to be part of a single line, up to a character threshold.
- After a character threshold, a semantic boundary should be followed by a line break.

A simpler set of rules reduces the opens the door to potential automation (a program would not need to make as many complicated decisions), and still achieves part of our original goal: changes now reflect changes to ideas within semantic boundaries, and more accurately reflect the idea being changed.

Returning to the *Lorem ipsum* example, with this version of semantic line breaks, our change might look like:

```diff
- Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
+ Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor oh I am so hungry ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
```

In this diff, it is significantly clearer what *idea* has changed, as encapsulated by the sentence it belongs in. This makes it easier to understand the context of the change being made, reason about it, and open discussions regarding it.

I've taken a stab at creating just such a tool, [Readable](https://github.com/bobheadxi/readable), which will add semantic line breaks to any document for you with a single command, for example `readable fmt **/*.md`.

It will also feature commands to preview changes, perform changes as you edit, and checks that can be run in continuous integration. So far it seems very promising, but there are a lot of edge cases to sort out and fix still.

Readable is being built in [TypeScript](https://www.typescriptlang.org/) with [Deno](https://deno.land/), a handy new TypeScript and Javascript runtime. Follow the project on [GitHub](https://github.com/bobheadxi/readable)!
