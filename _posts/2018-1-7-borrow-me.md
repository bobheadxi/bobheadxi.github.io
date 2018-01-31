---
title: ":department_store: Social Lending Platform"
layout: post
date: 2018-01-07 12:00
tag:
- python
- django
- docker
- hackathon
image: https://koppl.in/indigo/assets/images/jekyll-logo-light-solid.png
headerImage: false
projects: true
hidden: true # don't count this post in blog pagination
description: "a goodwill-based marketplace for sharing small, everyday items"
category: project
author: robert
externalLink: false
---

<p align="center">
    <img src="/assets/images/projects/borrow-me-1.png" />
</p>

<p align="center">
    <a href="https://github.com/bobheadxi/borrow-me">
        <img src="https://img.shields.io/badge/GitHub-borrow--me-6fd0f0.svg?style=for-the-badge" />
    </a>
</p>

<p align="center">
    <img src="https://img.shields.io/badge/hackathon-nwHacks%202018-green.svg" />
    <img src="https://img.shields.io/github/languages/count/bobheadxi/borrow-me.svg" />
</p>

Borrow Me! is an AirBNB-style service for all the small everyday things you might need in life - pencils, erasers, chargers, phones, and so on. No money is involved: lending items and returning things on time allows you accumulate karma, which is the currency of Borrow Me.

The service is built on Django and uses a Postgres database, both of which are managed by Docker for deployment. It features user logins and accounts, and the front end has a feed for available items as well as account management features that allow you to see what items you are borrowing, when they are due, as well as check what items you have put listed as available.