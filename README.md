# bobheadxi.dev [![website status](https://img.shields.io/website/https/bobheadxi.dev.svg?down_color=lightgrey&down_message=offline&label=website&up_message=online)](https://bobheadxi.dev) <img align="right" width=76 src="/assets/images/profile.jpg"/>

This is the [Jekyll](https://jekyllrb.com/) source for my website and blog, [**`bobheadxi.dev`**](https://bobheadxi.dev).
It is a *heavily* modified version of the [indigo theme](https://github.com/sergiokopplin/indigo),
and is hosted using [GitHub Pages](https://pages.github.com/). All opinions in blog posts, writeups, etc. are my own.

## Structure

##### `_posts`

It says "posts" but it's been repurposed to be the source of all my [blog posts](https://bobheadxi.dev/blog),
[experience pages](https://bobheadxi.dev), and [project pages](https://bobheadxi.dev/open-source).

##### `assets`

Source for most of the images and stuff used throughout the site.

##### `open-source`

Source for [`bobheadxi.dev/open-source`](https://bobheadxi.dev/open-source).

##### `r`

Source for my redirect links (ie `https://bobheadxi.dev/r/...`).

#### `_includes`, `_layouts`

Source for various site components.

#### `_sass`

Source for the site's styling.

## Development

You'll need [Ruby](https://www.ruby-lang.org/en/documentation/installation/) and [Bundler](https://bundler.io/) installed.

```
make install
make serve
```
