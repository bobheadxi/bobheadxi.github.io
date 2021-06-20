# bobheadxi.dev ![Checks status](https://github.com/bobheadxi/bobheadxi.github.io/workflows/Checks/badge.svg) [![website status](https://img.shields.io/website/https/bobheadxi.dev.svg?down_color=lightgrey&down_message=offline&label=website&up_message=online)](https://bobheadxi.dev) <img align="left" width=128 src="/assets/images/profile.jpg"/>

This is the [Jekyll](https://jekyllrb.com/) source for my website and blog, [**`bobheadxi.dev`**](https://bobheadxi.dev).
It is a [*heavily*](https://bobheadxi.dev/march-2020-site-updates/) [modified](https://bobheadxi.dev/introducing-dark-mode) version of the [indigo theme](https://github.com/sergiokopplin/indigo),
and is hosted using [GitHub Pages](https://pages.github.com/). All opinions in blog posts, writeups, etc. are my own.

<br />

### Structure

##### [`content`](/content)

Markdown source files for all content on the site ([`_posts`](content/_posts), [`_open-source`](content/_open-source), and [`_experience`](content/_experience)), configured as Jekyll Collections (see [`_config.yml`](./_config.yml)).

##### [`open-source`](/open-source)

Source for [`bobheadxi.dev/open-source`](https://bobheadxi.dev/open-source).

##### [`assets`](/assets)

Source for most of the images and stuff used throughout the site.

##### [`r`](/r)

Source for my redirect links (ie `https://bobheadxi.dev/r/...`).

##### [`_includes`](/_includes), [`_layouts`](/_layouts), [`_sass`](/_sass)

Source for various site components and styling.

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
