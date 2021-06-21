---
title: "June 2021 Updates for bobheadxi.dev"
layout: post
image: false
headerImage: false
diagrams: false
tag:
- javscript
- experiment
- jekyll
- my-website
category: blog
author: robert
description: Dark mode! New typography! Refined design!
---

With dark mode on every website nowadays, my website seems to have fallen a bit behind the times. I decided it was about time to give my website a bit of a facelift!

This round of improvements didn't strictly happen this month, but a lot of it was spurred on by my recent reading of the [iA Design Blog](https://ia.net/design/blog). I think their website is absolutely gorgeous, and it made the lacklustre of `bobheadxi.dev` all the more apparent.

For the unfamiliar, my site started off over 2 years ago with the [indigo Jekyll theme](https://github.com/sergiokopplin/indigo). I have since made quite a number of changes to it, and started writing about these changes [last year](/march-2020-site-updates).

I quite like how things turned out for this set of changes - hope you do as well!

## Refinements

### Updated typography

A big part of `bobheadxi.dev` is my blog posts, even though I'm unsure how many people read them (Google Analytics indicates a lot of traffic, particularly on my *really* old [Object Casting in Javascript](/object-casting-in-javascript/) post). Anyway, I've always been rather dissatisfied with the reading experience on my site, but could never quite put my finger on what exactly was wrong with it.

All I knew was that I didn't like the previous fonts - *‌Helvetica Neue* - but until I started using [iA Writer](https://ia.net/writer) recently, I didn't have much of an inkling of what font I would like.

iA Writer uses these gorgeous fonts - aptly named *Mono*, *Duo*, and *Quattro* - that I think looks *so nice* when typing and reading. They have a [neat blog post introducing these fonts](https://ia.net/writer/blog/a-typographic-christmas), and while I'm not really sure what this stuff means, I decided to  make the switch.

This site now uses *Quattro* as its serif font, and *Mono* as its monospaced font. I think the results are quite nice.

### The big picture

I like to include all sorts of media in my blog posts - images, code snippets, diagrams, quotes, and more. Unfortunately, I also like somewhat narrow widths for my content, which makes for a poor viewing experience for various forms of media.

On the [Sourcegraph Blog]() (and I recall that you can do this on Medium as well), I noticed that images were "blown up" - wider than the content - and I thought the effect looked quite nice, giving an expansive canvas for media to be enjoyed while still maintaining a nice reading experience for all the other stuff.

To do this myself, I turned images I wanted to be blown up into `<figure>` elements, and gave them expanded widths, along with `<figcaption>`. This also served nicely to standardize the raw HTML I'd been previously using to give images captions.

![](../../assets/images/dark-mode/wide-image.png)

Code blocks ran into similar problems, where snippets I didn't careful adjust to adhere to an 80-character line limit would have to be scrolled to viewed, even on very wide screens. So I made them massive.

![](../../assets/images/dark-mode/wide-code.png)

I've also always liked the big quotes used in magazine and newspaper sites to give quotes an even more authoritative and dramatic feel - so quotes joined the big club.

![](../../assets/images/dark-mode/wide-quote.png)

Hopefully these changes make the reading experience a bit less monotonous, to make up for my boring content!

### Outdented heading anchors

In iA Writer, headings get nicely outdented '#'s like so:

![](../../assets/images/dark-mode/header-outdent-ia.png)

I quite like how this looks, so I tried to replicate it on my site. I currently generate somewhat similar-looking (but not outdented) anchor links using [`allejo/jekyll-anchor-headings`](https://github.com/allejo/jekyll-anchor-headings), which allows a little bit of customization - I can give the anchor link elements a class, for example, and style it through that.

{% raw %}

```html
<div class="post-content">
    {% include anchor_headings.html html=content anchorBody='#' anchorClass='heading-anchor' beforeHeading=true %}
</div>
```

{% endraw %}

Turns out the outdenting can be achieved using the handy `translateX` transformation, and a bit of `@media` helps me scale this effect for smaller screens (where outdenting could position the anchors very close to the edge of your screen).

```sass
h1, h2, h3, h4
	// ... some CSS
	> .heading-anchor
		position: absolute
		transform: translateX(-2rem)
		@media #{$tablet}, #{$mobile}
			position: inherit
			transform: none
```

Sadly, I wasn't able to figure out a nontrivial way to have the number of '#'s correspond to the depth of the heading, but I figured this was close enough, and is definitely an improves the look of headings (in my opinion).

![](../../assets/images/dark-mode/header-outdent-bob.png)

### Bold introductions

Inspired by the [iA Design Blog](https://ia.net/design/blog).

![](../../assets/images/dark-mode/wide-intro.png)

This inspires me to write more interesting and captivating introductory paragraphs.

### Insightful lists

I just learned about Jekyll's `post.excerpt` feature that gives you the first paragraph of a blog post. Again inspired by the iA Design Blog, which uses excerpts instead of custom descriptions to great effect, I decided to use them here as well.

![](../../assets/images/dark-mode/light-blog-listing.gif)

I think this gives a far better preview into the content of each post, and makes them look a lot more important.

I also made minor improvements such as adding an on-hover effect to the clickable tags, which previously had no indication they were clickable.

## Dark mode

And last but not least, the star of today's show... dark mode! Because no site is complete without one.

![](../../assets/images/dark-mode/light-to-dark.gif)

Particularly happy with this detail:

![](../../assets/images/dark-mode/dark-blog-listing.gif)

Previously used SASS variables:

```sass
$alpha: #333

.my-class
	color: $alpha
```

Unfortunately, this is compiled at build time, and cannot be used to respond to `prefers-color-scheme: dark`

```sass
[data-theme="theme-light"]
    --background: #ffffff
    --alpha: #333
    --beta: #222
    --gama: #aaa
    --delta: #5A85F3
    --epsilon: #ededed
    --zeta: #666

[data-theme="theme-dark"]
    --background: #141414
    --alpha: #aaa
    --beta: #eeeeee
    --gama: #474747
    --delta: #5A85F3
    --epsilon: #202020
    --zeta: #929292
```

```js
var prefersDark = false;
function setDarkMode(isDark) {
    const theme = `theme-${isDark ? 'dark' : 'light'}`;
    document.querySelector('html').dataset.theme = theme;
    prefersDark = isDark;
    console.log(`Set ${theme}`);
}
```

Set initial theme:

```js
const prefersDarkMatch = window.matchMedia('(prefers-color-scheme: dark)');
setDarkMode(prefersDarkMatch.matches);
```

Change when your preferences change:

```js
prefersDarkMatch.addEventListener('change', (e) => setDarkMode(e.matches));
console.info(`Call 'setDarkMode(${!prefersDark})' to ${prefersDark ? 'disable' : 'enable'} dark mode`);
```

## Up next

There are still a lot of issues with dark mode - most noticeably the company logos I'm using that don't have transparent backgrounds, but also a few contrast issues in code highlighting.

I recently wrote a newsletter featuring a ludicrous number of footnotes, and now I want to get Tufte-style footnotes here so that I can abuse them in my blog posts as well. Sadly, I haven't found a particularly elegant solution to this, so I'm putting it off for now.

There also seems to be an issue with the tags page where posts from different collections do not get included that I definitely want to fix now that interaction with tags is more prominent.

That's all for now - feel free to highlight anything on this post if you have comments for questions!