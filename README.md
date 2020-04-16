# bobheadxi.dev ![Checks status](https://github.com/bobheadxi/bobheadxi.github.io/workflows/Checks/badge.svg) [![website status](https://img.shields.io/website/https/bobheadxi.dev.svg?down_color=lightgrey&down_message=offline&label=website&up_message=online)](https://bobheadxi.dev) <img align="left" width=128 src="/assets/images/profile.jpg"/>

This is the [Jekyll](https://jekyllrb.com/) source for my website and blog, [**`bobheadxi.dev`**](https://bobheadxi.dev).
It is a *heavily* modified version of the [indigo theme](https://github.com/sergiokopplin/indigo),
and is hosted using [GitHub Pages](https://pages.github.com/). All opinions in blog posts, writeups, etc. are my own.

<br />

### Structure

##### [`_posts`](/_posts)

It says "posts" but it's been repurposed to be the source of all my [blog posts](https://bobheadxi.dev/blog),
[work experience recaps](https://bobheadxi.dev/#work-experience), and [project pages](https://bobheadxi.dev/open-source).

##### [`open-source`](/open-source)

Source for [`bobheadxi.dev/open-source`](https://bobheadxi.dev/open-source).

##### [`assets`](/assets)

Source for most of the images and stuff used throughout the site.

##### [`r`](/r)

Source for my redirect links (ie `https://bobheadxi.dev/r/...`).

##### [`_includes`](/_includes), [`_layouts`](/_layouts)

Source for various site components.

##### [`_sass`](/_sass)

Source for the site's styling.

<br />

### Development

You'll need [Ruby](https://www.ruby-lang.org/en/documentation/installation/) and [Bundler](https://bundler.io/) installed.

```sh
make install
make serve
```

For styling, I use [`client9/misspell`](https://github.com/client9/misspell) (requires Go) and [`igorshubovych/markdownlint-cli`](https://github.com/igorshubovych/markdownlint-cli) (requires Node). To install and run them:

```sh
make install-checks
make checks
```
