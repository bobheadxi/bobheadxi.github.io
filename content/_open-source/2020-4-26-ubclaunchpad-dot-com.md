---
title: "✨ UBC Launch Pad Official Website"
layout: post
tag:
- vue
- typescript
- scss
- launch-pad
image: https://raw.githubusercontent.com/ubclaunchpad/ubclaunchpad.com/master/.static/banner.png
headerImage: true
description: "<i>ubclaunchpad.com</i> - the new official website for Launch Pad, UBC's student-lead software engineering club"
author: robert
star: true
externalLink: false
badges:
- <img src="https://img.shields.io/website/https/ubclaunchpad.com.svg" />
- <img src="https://img.shields.io/github/languages/top/ubclaunchpad/ubclaunchpad.com.svg?color=purple" />
---

<p align="center">
    <img src="/assets/images/posts/introducing-new-launch-pad-site/landing.gif" width="100%" />
</p>

<p align="center">
  <a href="https://github.com/ubclaunchpad/ubclaunchpad.com">
      <img src="https://img.shields.io/badge/github-ubclaunchpad.com-teal.svg?style=for-the-badge" alt="GitHub Repository"/>
  </a>
</p>

<p align="center">
  <a href="https://github.com/ubclaunchpad/ubclaunchpad.com/actions?workflow=Checks">
    <img src="https://github.com/ubclaunchpad/ubclaunchpad.com/workflows/Checks/badge.svg"
      alt="Checks Status" />
  </a>
  <a href="https://app.netlify.com/sites/ubclaunchpad/deploys">
    <img src="https://api.netlify.com/api/v1/badges/63f72100-a34c-4ad7-b47c-8b85c179202f/deploy-status"
      alt="Deploy Status" />
  </a>
  <img src="https://img.shields.io/github/languages/top/ubclaunchpad/ubclaunchpad.com.svg?color=purple" />
  <a href="https://ubclaunchpad.com">
    <img src="https://img.shields.io/website?url=https%3A%2F%2Fubclaunchpad.com" />
  </a>
</p>

[UBC Launch Pad is a student-run software engineering club](/what-is-launch-pad) at the University of British Columbia. I previously worked on [the club's old website](/ubclaunchpad-site), but by mid-2019 the website was showing its age and had not been kept up to date with our refreshed branding. In April 2020, using designs provided by UBC Launch Pad's design team, I built a prototype of a new website in 2 days, and worked with a few contributors to bring the prototype to completion and launch in a [total of just 8 days](https://medium.com/ubc-launch-pad-software-engineering-blog/introducing-the-new-launch-pad-website-42175181d644)!

The new website was built from the ground up to solve two main pain points of its predecessor: the lack of a modern web framework (which made the previous site difficult to build on top of), and the fact that almost all content was hardcoded (which made it difficult for new members to update the website). To remedy these problems, the new website:

* is built in **[Vue.js](https://vuejs.org/) and [TypeScript](https://www.typescriptlang.org/)**, to improve code reuse and have some self-documentation built in via static types
* is structured to fit our design, with each section of the vertically-scrolling website being a self-contained component and a set of shared utilities, styles, and components to make it **effortless to implement new sections, animate them, and have them fit in with the rest of the website**
* has a [**robust contribution guide**](https://github.com/ubclaunchpad/ubclaunchpad.com/blob/master/CONTRIBUTING.md) featuring a wide variety of tips, tricks, and resources for making changes to the website
* features a **comprehensive, self-documenting configuration system** that can be used to easily toggle entire website sections and change the content of frequently-updated sections, such as the website's [featured projects](https://ubclaunchpad.com/), from a single TypeScript-based configuration file. This means configuration changes are inherently self-validating, and allows us to [automatically generate comprehensive documentation](https://ubclaunchpad.com/config) from our type definitions

<br />

<p align="center">
  <img src="/assets/images/posts/introducing-new-launch-pad-site/responsive.png" width="80%" />
</p>

<p align="center">
  <i style="font-size:90%;">The redesigned website is still fully responsive!</i>
</p>

In addition to the features listed above, I also worked on:

* making the website **fully responsive** across all screen sizes
* integrating with our hosting provider [Netlify](https://www.netlify.com/) to **automatically generate [redirect links](https://github.com/ubclaunchpad/ubclaunchpad.com/blob/master/USING.md#redirect-links) from site configuration**
* designing and building a **new way to browse our projects** through interactive modals, which teams can customise in the site configuration to feature media (images or YouTube videos) and links of their choice. The modals can also generate [links that can be shared to bring visitors directly to the project modal of their choice](https://ubclaunchpad.com?project=inertia#projects)!

<p align="center">
  <img src="/assets/images/projects/ubclaunchpad-dot-com/project-modal.gif" width="80%" />
</p>

<p align="center">
  <i style="font-size:90%;">Effortless dive into a project for more details with the new website's modal-based projects showcase</i>
</p>

Check out my pull requests in more detail [on GitHub](https://github.com/ubclaunchpad/ubclaunchpad.com/pulls?q=is%3Apr+author%3Abobheadxi+is%3Aclosed),
and see the website [live at `ubclaunchpad.com`](https://ubclaunchpad.com)!

<br />
