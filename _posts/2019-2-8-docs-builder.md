---
title: "Automated Documentation Builds with Slate"
layout: post
date: 2019-2-8 11:00
image: https://cdn-images-1.medium.com/max/5528/1*fSQLmcXU6XELwEw65nlJSQ.png
headerImage: true
tag:
- docs
- automation
- bash
- inertia
- launch-pad
category: blog
author: robert
tech_writeup: true
description: 'Turning a template into an automated documentation builder'
alt_location:
  type: Medium
  url: https://medium.com/@bobheadxi/turning-slate-into-a-proper-documentation-builder-d0cf31abf459
---

I’m currently working with [RTrade Technologies, Ltd.](undefined) and [a documentation website](https://gateway.temporal.cloud/ipfs/Qma4DNFSRR9eGqwm93zMUtqywLFpTRQji4Nnu37MTmNntM/account.html#account-api) was recently set up for one of our APIs. I thought it looked great, and slick, and super nice.

I was told the documentation was generated using a project called [Slate](https://github.com/lord/slate), and after taking a look I knew I had to try it out. It’s very pretty.

![[Wow!](https://raw.githubusercontent.com/lord/img/master/screenshot-slate.png)](https://cdn-images-1.medium.com/max/2800/1*NMCPwETJJL7-pIy4XCitYA.png)

First step: read some docs. “[Getting Started with Slate](https://github.com/lord/slate#getting-started-with-slate)” seemed like a good place to get started.

![](https://cdn-images-1.medium.com/max/3988/1*Kbh0N4Y-zei5FugpvJBIlA.png)

Mhm, looking good so far. I’ve got all those things.

![](https://cdn-images-1.medium.com/max/3216/1*ADt1iYcAHB3PKLu2iRf9PA.png)

Hold up. What? Is this telling me that I can’t just “use” this thing to build documentation as a tool? I need to fork it and change it?

Okay great. Well, I don’t want to do that. I want my documentation to be part of my repository, so it can be versioned alongside our code, and I don’t want to carry around the baggage of an entire repository alongside my documentation. So let’s not do that, and try to hack Slate into a proper doc builder.

## Making the Script

<center>
  <iframe width="560" height="315" src="https://www.youtube.com/embed/KFLru5OFtMI" frameborder="0" allowfullscreen />
</center>

<br />

```sh
mkdir -p docs_build
cd docs_build
if [ ! -d slate ]; then
  git clone [https://github.com/lord/slate.git](https://github.com/lord/slate.git)
fi
```

To start off, I want my script to grab the repo (I’ll need it one way or another) and chuck it into a temporary directory. I called it docs_build and chucked it into my .gitignore where it belongs.

Next, I’ll go ahead and symlink everything that I’m *supposed *to change in my “fork” from where I want my **actual **documentation to be — I decided to call it docs_src — into the cloned Slate repo.

```sh
# in /docs_build

# documentation
ln -fs "$(dirname "$(pwd)")"/docs_src/index.html.md \
  slate/source/index.html.md

# CSS variables (colours, etc.)
ln -fs "$(dirname "$(pwd)")"/docs_src/stylesheets/_variables.scss \
  slate/source/stylesheets/_variables.scss

# cute logo!
ln -fs "$(dirname "$(pwd)")"/.static/inertia.png \
  slate/source/images/logo.png
```

Note that when creating a symlink with ln -s , you should use the full directory path as your source, or the link could point to something nonexistent. In this case, I opted to use pwd and join it to the file I’m trying to link from.

Next, I’ll need to install Slate’s dependencies:

```sh
# in /docs_build

cd slate
bundle install
```

And hypothetically I should be good to go!

```sh
# in /docs_build/slate

# build docs into the /docs directory
bundle exec middleman build --clean --build-dir=../../docs
```

The build works, and all seems well. Let’s check out live reload:

```sh
# in /docs_build/slate

bundle exec middleman server --verbose
```

If you’re following along, you’ll probably notice that this step tragically does not work properly — editing a file in my /docs_src directory does not trigger a reload.

This probably happens because a symlink doesn’t usually play well with file watchers, and poking around the Middleman repository issues reveals a few (such as [this one](https://github.com/middleman/middleman/issues/1690)) that reveals this is likely the problem. Some more digging surfaces a [files.watch feature](https://github.com/middleman/middleman/issues/2054#issuecomment-280082417) that seems to do what I want: add my symlink source directories as a trigger for rebuilds.

The problem is, I need to add this to config.rb , which is in the Slate repository, and I want to maintain my Slate-as-a-doc-builder feature, which means any configuration changes I make must be scripted and perfectly reproducible.

```sh
TEMPLATE_FILES_WATCH= \
  "files.watch :source, path: File.join(root, '../../docs_src')"

if ! grep -q "$TEMPLATE_FILES_WATCH" slate/config.rb ; then
  echo "$TEMPLATE_FILES_WATCH" \
    >> slate/config.rb
fi
```

Nice! This script checks for if my custom files.watch directive is already in Slate’s config.rb , and if not, append it to the end. Now running the Middleman server successfully live-reloads my changes to [http://localhost:4567](http://localhost:4567) !

I’m not quite done though — I also want my site to have a favicon. I figured this might be a configuration option in index.html.md , but [it’s not](https://github.com/lord/slate/wiki/Adding-a-favicon):

![Hey, I just realized the author’s name is Robert as well!](https://cdn-images-1.medium.com/max/3264/1*FZ74gSKGsxTeZHzZUvVREg.png)

Well that’s just great. Time to whip out some `sed`:

```sh
LAYOUT="slate/source/layouts/layout.erb"

if ! grep -q "<%= favicon_tag 'favicon.ico' %>" "$LAYOUT" ; then
  sed -i '' '/<head>/a\
  <%= favicon_tag '\''favicon\.ico'\'' %>
  ' slate/source/layouts/layout.erb
fi
```

This checks the layout for the favicon tag, and if it’s not there, insert it right after the <head> tag.

![There it is!](https://cdn-images-1.medium.com/max/3156/1*IWlraMnz3mC4t9u_UW6-xQ.png)

Then I had to add the favicon to my list of things to symlink:

```sh
ln -fs "$(dirname "$(pwd)")"/.static/favicon.ico \
  slate/source/images/favicon.ico
```

And it worked! bundle exec middleman server kindly updated my local deployment to show my shiny new favicon:

![Marvellous.](https://cdn-images-1.medium.com/max/2000/1*Z78Fb9yTztRALIwgThmaFw.png)

## Finishing Touches

* I tied everything up together into a [tidy (I hope), documented (I think) script](https://github.com/ubclaunchpad/inertia/blob/master/.scripts/build_docs.sh).
* I also added a some Makefile targets to run the build script and the live-reload server.
* Of course, [writing and building documentation needs documentation as well](https://github.com/ubclaunchpad/inertia/blob/master/CONTRIBUTING.md#documentation).
* I [forked Slate](https://github.com/bobheadxi/slate) (and [opened a PR upstream](https://github.com/lord/slate/pull/1059)) to add some more customization features (mostly in the CSS variables), and am currently using this fork in my script.
* I deployed the documentation to [https://inertia.ubclaunchpad.com/](https://inertia.ubclaunchpad.com/)

Here’s what the documentation site looks like now:

![wheeeee](https://cdn-images-1.medium.com/max/5528/1*fSQLmcXU6XELwEw65nlJSQ.png)

Feel free to check out the [commit](https://github.com/ubclaunchpad/inertia/commit/40bfc25c78e5110c690b379b96476f258d3d897b) or [pull request](https://github.com/ubclaunchpad/inertia/pull/536) that added all this stuff to [Inertia](https://github.com/ubclaunchpad/inertia), a [UBC Launch Pad](https://www.ubclaunchpad.com/) project!
