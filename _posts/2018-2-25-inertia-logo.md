---
title: "The Inertia Logo and README Design"
layout: post
date: 2018-02-25 10:00
tag:
- doodle
- logo
image: https://github.com/ubclaunchpad/inertia/blob/master/.static/inertia-with-name.png?raw=true
headerImage: true
photography: true
hidden: true # don't count this post in blog pagination
description: READMEs that really say "READ ME"
hidedescription: false
category: photography
author: robert
externalLink: false
---

There isn't too much a project on GitHub can do in terms of looking attractive and professional outside of a clean name, concise description, and a clean README. In the past I hadn't really thought much about it since my projects were of rather... low quality and were unlikely to see widespread use. Take this README from my [very first personal project](https://bobheadxi.github.io/facebook-spotify-bot/):

<p align="center">
    <a href="https://github.com/bobheadxi/facebook-spotify-chatbot">
        <img src="/assets/images/posts/facebook-spotify-readme.png" width="80%">
    </a>
</p>

<p align="center">
    <i style="font-size:90%;">Hmmm...</i>
</p>

I figured pretty early on that I really liked the look of badges, and given their popularity it doesn't seem like I'm the only one. I'm not really sure what makes them so comfortable to look at - perhaps it's something about their colourfulness, or their nice rectangular roundness, or how easy they are to parse at a glance. There is eve an [entire project](https://github.com/badges/shields) dedicated to making these badges. If you're interested, they have a neat [design document](https://github.com/badges/shields/blob/master/spec/SPECIFICATION.md) specifying what makes a good badge as well as a [brief history](https://github.com/badges/shields/blob/master/spec/motivation.md) of the badges.

Badges aren't just nice in READMEs - I also use them in my [Project](https://bobheadxi.github.io/projects/) pages:

<p align="center">
    <a href="https://bobheadxi.github.io/r-android-appstore/">
        <img src="/assets/images/posts/reddit-android-project-page.png" width="60%">
    </a>
</p>

<p align="center">
    <i style="font-size:90%;">Badges!</i>
</p>

With such limited room to make an impression on a reader, badges in READMEs convey a lot of important information to potential users and contributors, such as the presence of continuous integration and tests or whether the project is well-maintained (dependency statuses, etc), which can contribute a lot (for me at least) to the perceived quality of the project.

And, as with all things, an eye-catching logo goes a long way.

<p align="center">
    <img src="https://raw.githubusercontent.com/Instagram/IGListKit/master/Resources/logo-animation.gif" width="80%">
</p>

<p align="center">
    <i style="font-size:90%;">A quality, animated README logo from Instagram's <a href="https://github.com/Instagram/IGListKit">IGListKit</a> library.</i>
</p>

I learned quite a few things when I first saw [IGListKit's README](https://github.com/Instagram/IGListKit/blob/master/README.md):
- you can use HTML to some degree in README's, which are typically pure Markdown and doesn't support overly fancy shenanigans
- with HTML you can center things
- badges can convey a lot more than continuous integration status - IGListKit lists their supported platforms in their badges

## The Inertia README and Logo

So of course I had to do something similar for [Inertia](https://github.com/ubclaunchpad/inertia), a project that we are hoping hobbyist users both within [UBC Launch Pad](http://www.ubclaunchpad.com) and in the wider Docker community will find useful, needed a bit of snazz. Here's what our README looked like originally:

<p align="center">
    <img src="/assets/images/posts/inertia-old-readme.png" width="90%">
</p>

<p align="center">
    <i style="font-size:90%;">Ehhhhh</i>
</p>

As a Golang project, I figured we might as well use a [Golang gopher](https://blog.golang.org/gopher)-inspired logo - it's a pretty popular option that is widely [used](https://github.com/golang/dep) [amongst](https://github.com/360EntSecGroup-Skylar/excelize) [Golang](https://github.com/spf13/cobra) [libraries](https://github.com/src-d/go-git), both official and unofficial.

<p align="center">
    <img src="https://golang.org/doc/gopher/biplane.jpg" width="50%">
</p>

<p align="center">
    <i style="font-size:90%;">An official gopher asset that I used in <a href="https://github.com/ubclaunchpad/inertia/blob/master/.static/inertia-v0-0-2-slides.pdf">my first Inertia presentation.</a></i>
</p>

I wanted to preserve the typical lighthearted gopher style and convey the same feeling of momentum, but without the plane in the gopher that I first used. The goal of the Inertia project is to allow simple, painless continuous and manual deployment management.

<p align="center">
    <img src="https://blog.golang.org/gophergala/fancygopher.jpg" width="50%">
</p>

<p align="center">
    <i style="font-size:90%;">Most of Golang's fantastic gophers are by <a href="https://www.instagram.com/reneefrench/">Renee French</a>, who is amazing.</i>
</p>

As a visitor to the Inertia repository, these goals should hopefully be immediately conveyed by the logo. So I decided that the Inertia gopher would be unclothed (gasp!) and without any extraneous apparatuses. As for colour, I initially felt a simple black and white image would be fine, but after trying my hand at colouring it I thought it turned out fine.

<p align="center">
    <img src="/assets/images/posts/inertia-logo-progress.png">
</p>

<p align="center">
    <i style="font-size:90%;">Some initial drafts.</i>
</p>

A calm, leaping gopher seemed to do the trick. It took a very long time to make the speed trail thingos look right (and to be honest it still feels a bit off). Either way it felt like something was still missing - I figured a helmet might add a bit more of a "speedy" feel to the gopher, and give it some more character, despite what I said about extraneous apparatuses at first.

<p align="center">
    <img src="/assets/images/projects/inertia-gopher-only.png" width="40%">
</p>

<p align="center">
    <i style="font-size:90%;">Safety first everyone!</i>
</p>

I was personally pretty happy with this version. In my eyes the gopher even seemed to be smiling a little as it joyfully leapt towards the heavens. I considered tacking on the word "Inertia" alongside the gopher, since I felt some handwritten text would go along nicely with a handdrawn image - I did something similar with [my first Inertia presentation](https://github.com/ubclaunchpad/inertia/blob/master/.static/inertia-v0-0-2-slides.pdf), albeit with a stylised font instead.

<p align="center">
    <img src="/assets/images/posts/inertia-logo-progress-2.png" width="90%">
</p>

<p align="center">
    <i style="font-size:90%;">Doesn't seem quite right...</i>
</p>

Over the course of half an hour I must have written the word "Inertia" at least a hundred times. My awful handwriting did not help in the slightest and it drove me insane. Towards the end I gave up trying to write in a straight line and resorted to manually moving words and characters until they looked alright. After several iterations I also gave up on including "UBC Launch Pad" - it didn't add much and it seemed rather pointless.

Eventually, though, I thinned out the text and finally ended up with something that I thought was rather nice:

<p align="center">
    <img src="https://github.com/ubclaunchpad/inertia/raw/master/.static/inertia-with-name.png" width="50%">
</p>

<p align="center">
    <i style="font-size:90%;">Wheeeeeeeeeeeeeeee!</i>
</p>

The Inertia gopher then moved onto the [Inertia README](https://github.com/ubclaunchpad/inertia) alongside some nice badges and lived happily ever after.

<p align="center">
    <img src="/assets/images/posts/inertia-new-readme.png">
</p>

<p align="center">
    <i style="font-size:90%;">Test coverage not quite high enough to show off yet.</i>
</p>
