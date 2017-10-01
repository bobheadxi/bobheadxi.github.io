---
layout: page
title: Projects
---
# My Projects
Featured here are some of the things I have been doing in my spare time, though I am always working on new things that might not be listed here. Drop by my [GitHub](https://github.com/bobheadxi) to see more :-)

__________________
### "r/Android App Store" Android Application
[ `open-source` ]    
*Android, Java, JUnit / [Source](https://github.com/d4rken/reddit-android-appstore)*  

The "r/Android App Store" is an Android application that allows users to conveniently browse a massive [community-curated list of apps](https://www.reddit.com/r/android/wiki/apps) including all sorts of Android applications and games. The app features a comprehensive featureset and boasts a very strong userbase - the two major releases I participated in, v0.7 and v0.8, already has over [10,000 cumulative downloads](http://www.somsubhra.com/github-release-stats/?username=d4rken&repository=reddit-android-appstore). With over 20 merged pull requests, some of my contributions include:
- **new features** such a redesign of one of the app's pages, the ability to automatically tag newly added apps as "new", the ability to save selected filters, a popup to show changelogs pulled from GitHub, markdown to HTML conversion for text, and more

- **refactoring** parts of the app's backend to utilise [Dagger](https://github.com/google/dagger)'s dependency injection capabilities to enable easier testing, as well as making performance improvements by providing application-scoped (singleton) [OkHttpClient](https://github.com/square/okhttp) and [Retrofit](https://github.com/square/retrofit) instances through Dagger

- rewriting **unit tests** using [JUnit](http://junit.org/junit5/) and [Mockito](http://site.mockito.org) for one of the refactored modules for more comprehensive coverage, and provided unit tests for some of my own contirbutions

- a wide range of **bug fixes** to improve the app's stability

- integrating **test coverage reporting** into the project's CI tool, [Travis](https://travis-ci.org), using [Coveralls](https://coveralls.io)

- **reviewing pull requests** made by new contributors and addressing bug reports and issues raised by the community

Check out my pull requests in more detail [here](https://github.com/d4rken/reddit-android-appstore/pulls?utf8=✓&q=is%3Apr%20is%3Aclosed%20author%3Abobheadxi%20is%3Amerged%20base%3Adev)!

![](https://github.com/d4rken/reddit-android-appstore/blob/dev/art/preview-v080.png?raw=true)

__________________  
### Facebook Messenger Bot with Spotify Integration
[ `personal project` ]   
*Node.js, JavaScript, Mocha / [Source](https://github.com/bobheadxi/facebook-spotify-chatbot)*   

This bot allows you to interact with [Spotify](http://spotify.com) through the [Facebook Messenger](https://www.messenger.com) interface and allows the creation of more tightly controlled public playlists. Written in JavaScript using the [Node.js](https://nodejs.org/en/) framework, hosted on [Heroku](https://www.heroku.com), and making extensive use of [Facebook](https://developers.facebook.com/docs/messenger-platform/) and [Spotify](https://developer.spotify.com/web-api/)'s RESTful APIs, this bot currently features:
- **song search**, which presents the user with an attractive scrolling view that shows the song name, album art, album name and artist

- access to 30-second **song previews** that can be played within Messenger

- the ability to **"host" a playlist** - other users can then request for songs to be added to the playlist, which then have to be approved by the host

- **unit tests** written using [Mocha](https://mochajs.org) and [Sinon](http://sinonjs.org)

- **continuous integration tools** and code coverage reporting built in to the repository with [Travis](https://travis-ci.org) and [Coveralls](https://coveralls.io)

All this is conveniently done through Facebook Messenger in a seamless experience. I am currently working on almost entirely rewriting the backend, building a comprehensive testing suite, and setting up a cleaner development pipeline that will ensure I always have a stable instance of the bot up on Heroku. I will then be submitting the bot to Facebook to make it accessible to everyone.
![](https://github.com/bobheadxi/facebook-spotify-chatbot/blob/dev/screenshots/screenshots0-2-1.png?raw=true)

__________________