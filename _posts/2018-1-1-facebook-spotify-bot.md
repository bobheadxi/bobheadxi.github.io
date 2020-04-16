---
title: ":chicken: Facebook Messenger Bot with Spotify Integration"
layout: post
date: 2018-01-01 00:00
tag:
- javascript
- nodejs
- rest
image: https://koppl.in/indigo/assets/images/jekyll-logo-light-solid.png
headerImage: false
open_source: true
hidden: true # don't count this post in blog pagination
description: "a more controlled and interactive take on shared playlists and simple song searches"
category: open-source
author: robert
externalLink: false
badges:
- <img src="https://travis-ci.org/bobheadxi/facebook-spotify-chatbot.svg?branch=dev" />
- <img src="https://img.shields.io/github/languages/top/bobheadxi/facebook-spotify-chatbot.svg" />
- <img src="https://img.shields.io/github/contributors/bobheadxi/facebook-spotify-chatbot.svg" />
---

<p align="center">
    <img src="https://github.com/bobheadxi/facebook-spotify-chatbot/blob/dev/screenshots/screenshots0-2-1.png?raw=true" />
</p>

<p align="center">
    <a href="https://github.com/bobheadxi/facebook-spotify-chatbot">
        <img src="https://img.shields.io/badge/GitHub-facebook--spotify--chatbot-red.svg?style=for-the-badge" alt="Website Repository"/>
    </a>
</p>

<p align="center">
    <img src="https://travis-ci.org/bobheadxi/facebook-spotify-chatbot.svg?branch=dev" />
    <img src="https://img.shields.io/github/languages/top/bobheadxi/facebook-spotify-chatbot.svg" />
    <img src="https://img.shields.io/github/contributors/bobheadxi/facebook-spotify-chatbot.svg" />
</p>

Ever wanted to allow everyone to add songs to your playlist, but disliked how Spotify really allows *anyone* to add *anything* to your playlist if you open it up? This bot allows you to interact with [Spotify](https://spotify.com) through the [Facebook Messenger](https://www.messenger.com) interface and allows the creation of more tightly controlled public playlists. Built on [Node.js](https://nodejs.org/en/), hosted on [Heroku](https://www.heroku.com), and making extensive use of [Facebook](https://developers.facebook.com/docs/messenger-platform/) and [Spotify](https://developer.spotify.com/web-api/)'s RESTful APIs, this bot currently features:

* **song search**, which presents the user with an attractive scrolling view that shows the song name, album art, album name and artist

* access to 30-second **song previews** that can be seamlessly played from within Messenger

* the ability to **"host" a playlist** - other users can then request for songs to be added to the playlist, which then have to be approved by the host

* **robust song approval process** that involves both the host receiving a message to notify them of the request, and the requester receiving a message upon song approval, after which the requested song is seemlessly added to the host's Spotify playlist

* **unit tests** written using [Mocha](https://mochajs.org) and [Sinon](https://sinonjs.org)

* **continuous integration tools** and code coverage reporting built in to the repository with [Travis](https://travis-ci.org) and [Coveralls](https://coveralls.io)

All this is conveniently done through Facebook Messenger in a seamless experience. This project was my first major programming project, as well as my first solo project. Check out the GitHub repository for more details!
