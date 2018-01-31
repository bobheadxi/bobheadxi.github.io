---
title: ":rainbow: Open-Source Android Application"
layout: post
date: 2018-01-01 00:00
tag:
- android
- java
- open-source
image: https://koppl.in/indigo/assets/images/jekyll-logo-light-solid.png
headerImage: false
projects: true
hidden: true # don't count this post in blog pagination
description: "widely used portal for luxuriously browsing a popular community-curated collection of Android applications"
category: project
author: robert
star: true
externalLink: false
---

<p align="center">
    <img src="https://github.com/d4rken/reddit-android-appstore/blob/dev/art/preview-v080.png?raw=true" />
</p>

<p align="center">
    <a href="https://github.com/d4rken/reddit-android-appstore">    
        <img src="https://img.shields.io/badge/GitHub-r%2FAndroid%20App%20Store-red.svg?style=for-the-badge" alt="GitHub Repository"/>
    </a>
</p>

<p align="center">
    <img src="https://img.shields.io/github/downloads/d4rken/reddit-android-appstore/total.svg"
        alt="Total Downloads" />
    <img src="https://img.shields.io/github/stars/d4rken/reddit-android-appstore.svg" />        
    <img src="https://img.shields.io/github/languages/top/d4rken/reddit-android-appstore.svg" />
    <img src="https://img.shields.io/github/contributors/d4rken/reddit-android-appstore.svg" />
</p>

The "r/Android App Store" is an Android application that allows users to conveniently browse a massive [community-curated list of apps](https://www.reddit.com/r/android/wiki/apps) including all sorts of Android applications and games. The app features a comprehensive featureset and boasts a very strong userbase - the two major releases I participated in, v0.7 and v0.8, already has over [30,000 cumulative downloads](http://www.somsubhra.com/github-release-stats/?username=d4rken&repository=reddit-android-appstore). With over 20 merged pull requests, some of my contributions include:
- **new features** such a redesign of one of the app's pages, the ability to automatically tag newly added apps as "new", the ability to save selected filters, a popup to show changelogs pulled from GitHub, markdown to HTML conversion for text, and more

- **refactoring** parts of the app's backend to utilise [Dagger](https://github.com/google/dagger)'s dependency injection capabilities to enable easier testing, as well as making performance improvements by providing application-scoped (singleton) [OkHttpClient](https://github.com/square/okhttp) and [Retrofit](https://github.com/square/retrofit) instances through Dagger

- rewriting **unit tests** using [JUnit](http://junit.org/junit5/) and [Mockito](http://site.mockito.org) for one of the refactored modules for more comprehensive coverage, and provided unit tests for some of my own contirbutions

- a wide range of **bug fixes** to improve the app's stability

- integrating **test coverage reporting** into the project's CI tool, [Travis](https://travis-ci.org), using [Coveralls](https://coveralls.io)

- **reviewing pull requests** made by new contributors and addressing bug reports and issues raised by the community

Check out my pull requests in more detail [here](https://github.com/d4rken/reddit-android-appstore/pulls?utf8=✓&q=is%3Apr%20is%3Aclosed%20author%3Abobheadxi%20is%3Amerged%20base%3Adev)!
