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

This round of improvements didn't strictly happen this month, but a lot of it was spurred on by my recent reading of the [iA Design Blog](https://ia.net/design/blog). I thought that their website was absolutely gorgeous, and it made the lacklustre of `bobheadxi.dev` all the more apparent.

For the unfamiliar, my site started off over 2 years ago with the [indigo Jekyll theme](https://github.com/sergiokopplin/indigo). I have since made quite a number of changes to it, and started writing about these changes [last year](/march-2020-site-updates).

I quite like how things turned out for this set of changes - hope you do as well!

## Refinements

### Updated typography

A big part of `bobheadxi.dev` is my blog posts, even though I'm not sure how many people actually read them (Google Analytics indicates a lot of traffic, especially on my *really* old [Object Casting in Javascript](/object-casting-in-javascript/) post). Anyway, I've always been rather dissatisfied with the reading experience on my site, but could never quite put my finger on what exactly was wrong with it.

I was pretty sure I didn't like the previous fonts - *‌Helvetica Neue* and *Consolas* for monospaced content - but until I started using [iA Writer](https://ia.net/writer) recently, I didn't have much of an inkling of what font I would like.

iA Writer uses these gorgeous fonts - aptly named [Mono, Duo, and Quattro](https://ia.net/writer/blog/a-typographic-christmas) - and while I'm not really sure what this stuff means, I just know that it looks *so nice*.

![](https://ia.net/wp-content/uploads/2018/12/iA-Writer-Mono-Duo-Quattro-Differences-1.png)

### The big picture

I like to include all sorts of media in my blog posts - images, code snippets, diagrams, quotes, and more.

![](../../assets/images/dark-mode/wide-image.png)

![](../../assets/images/dark-mode/wide-code.png)

![](../../assets/images/dark-mode/wide-quote.png)

### Outdented heading anchors

In iA Writer, headings are get nicely outdented '#'s like so:

![](../../assets/images/dark-mode/header-outdent-ia.png)

![](../../assets/images/dark-mode/header-outdent-bob.png)

I generate heading anchors with [`allejo/jekyll-anchor-headings`](https://github.com/allejo/jekyll-anchor-headings).

{% raw %}

```html
<div class="post-content">
    {% include anchor_headings.html html=content anchorBody='#' anchorClass='heading-anchor' beforeHeading=true %}
</div>
```

{% endraw %}

```sass
h1, h2, h3, h4
	font-family: $fontSans
	color: var(--beta)
	-webkit-font-smoothing: antialiased
	text-rendering: optimizeLegibility

	> .heading-anchor
		position: absolute
		transform: translateX(-2rem)

		@media #{$tablet}, #{$mobile}
			position: inherit
			transform: none
```

## Refined design

Inspired by the [iA Design Blog](https://ia.net/design/blog).

![](../../assets/images/dark-mode/wide-intro.png)

![](../../assets/images/dark-mode/light-blog-listing.gif)

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
