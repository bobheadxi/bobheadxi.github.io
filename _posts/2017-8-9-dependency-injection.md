---
title: "Dependency Injection for Testable Code"
layout: post
date: 2017-08-09 22:12
image: https://miro.medium.com/max/321/1*ZHDFHf2l1dh__D7gvyIT4w.png
headerImage: true
tag:
- java
- android
- testing
star: false
tech_writeup: true
category: blog
author: robert
description: with Java and the Dagger library
---

As the summer progressed, my part time job selling pickles began to take up 4 to 7 hours per day, pretty much every single day. As fun as eating, chopping, packing, and talking about pickles was, I felt I needed a change of pace in my spare time. Something fun. Unfortunately, _Game of Thrones_ only came along once a week, so I filled the rest of my time with something just as fun: sitting in front of a laptop for hours on end.

I started off with a small Javascript project, my [Facebook Messenger bot](https://github.com/bobheadxi/facebook-spotify-chatbot).  Work on my bot, however, has dwindled over the last few weeks in favour of an open source project, the [r/Android App Store](https://github.com/d4rken/reddit-android-appstore). It is a neat little application that allows you to conveniently browse a list of apps curated by the folks over at [r/Android](https://reddit.com/r/Android), as well as games picked by the [r/AndroidGaming](https://reddit.com/r/AndroidGaming) community. There is a surprisingly large user base: release v0.6.0, which was the latest release when I first started working on the app, had over 19,000 direct downloads from GitHub, which doesn’t even include downloads from FDroid. The app features a nice variety of options including themes, filtering by category, search, and the ability to take a look at each app’s description and screenshots, courtesy of several scrapers. All this was largely built, it seems, by [Matthias Urhahn (d4rken)](https://github.com/d4rken) and [Garret Yoder (garretyoder)](https://github.com/garretyoder), whose code I will be frequently referencing in this post. As a side note, d4rken is also the developer of a popular Android app called [SD Maid](https://play.google.com/store/apps/details?id=eu.thedarken.sdm&hl=en) and he has been a tremendous help to me ever since I started working on the [r/Android App Store](https://github.com/d4rken/reddit-android-appstore).

- TOC
{:toc}

# Prelude
Recently I began looking into setting up some unit tests - the [project](https://github.com/d4rken/reddit-android-appstore) hardly had any tests at all, and according to our Coveralls report (a feature I added to our Travis CI a little while ago), we had a measly 10% code coverage. I figured doing this would be good practice, and might help with further development.

It had been a while since I lasted wrote any JUnit tests - the last time being earlier this year in a course I took in university - so I decided to start with the class `BodyParser`, which parses the wiki that lists all the apps within the r/Android community “app store”.

A parser, I thought, should be fairly simple to implement unit tests for. There was also already a simple test in place, which I could use as a starting point to build off of.

# The Problem
The preexisting test I mentioned:
```java
public class BodyParserTest {
    @Mock EncodingFixer encodingFixer;
    private BodyParser bodyParser;

    @Before
    public void setup() {
        // init encoding fixer, some other setup
        bodyParser = new BodyParser(encodingFixer);
    }

    @Test
    public void testBodyParser() throws IOException {
        // call `parseBody()` to test it
        Collection<AppInfo> appInfos = bodyParser.parseBody(TestBody.HTMLBODY);
        // various assertions
    }
}
```

And the class being tested, condensed for convenience:
```java
public class BodyParser {
    private final List<AppParser> appParsers = new ArrayList<>();
    private final CategoryParser categoryParser;

    public BodyParser(EncodingFixer encodingFixer) {
        categoryParser = new CategoryParser(encodingFixer);
        appParsers.add(new NameColumnParser(encodingFixer));
        appParsers.add(new PriceColumnParser(encodingFixer));
        appParsers.add(new DeviceColumnParser(encodingFixer));
        appParsers.add(new DescriptionColumnParser(encodingFixer));
        appParsers.add(new ContactColumnParser(encodingFixer));
    }

    public Collection<AppInfo> parseBody(String bodyString) {
        Collection<AppInfo> parsedOutput = new ArrayList<>();
        List<String> lines = Arrays.asList(bodyString.split("\n"));
        
        // function `parseCategoryBlocks()` calls the `parse()` function
        // of each of the `AppParser` classes in the list `appParser`
        parsedOutput.addAll(parseCategoryBlocks(new ArrayList<>(), lines));
        return parsedOutput;
    }

    // some helper methods
}
```

I first noticed the problem when I ran the test with coverage. With a single `bodyParser.parseBody(TestBody.HTMLBODY)`, the test managed to cover pretty much all the classes within the package, which includes the assorted `AppParser` implementations (`NameColumnParser`, `PriceColumnParser`, etc.) and `CategoryParser`. This occurred because all these classes were all dependencies that `BodyParser` relied upon - when `parseBody(String bodyString)` was called, the class made use of those dependencies, executing their code and resulting in the unintended test coverage.

If I’ve learnt anything from my course, ideally the unit test for a class would only test that particular class’s code. While very nice and everything for the Coveralls stats, this was problematic for effectively testing the package the question. If there was a problem with `PriceColumnParser`, for example, it would cause `BodyParserTest` to fail as well, even though the issue is not in `BodyParser`.

# Solution
To isolate BodyParser so that I only test its functionality, I needed to provide its dependencies externally. With a bit of Google searching, I found the proper term: [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection). The Wikipedia article states that:

> A dependency is an object that can be used (a service)… Passing the service to the client, rather than allowing a client to build or find the service, is the fundamental requirement of the pattern… This allows the class to make acquiring dependencies something else's problem.  

### Attempt 1: Providing dependencies via constructor
My first attempt at solving this was fairly straightforward. I noticed that in the preexisting test, the procedure for mocking out `EncodingFixer` with Mockito was a fairly straightforward one:
```java
@Mock EncodingFixer encodingFixer;
@Before
public void setup() {
    MockitoAnnotations.initMocks(this);
    // some more stuff
}
```

I figured that if I changed the constructor of `BodyParser` to take the dependencies as parameters, I could mock them out when setting up the test. With this in mind, I made an `AppParserSuite` to hold the five `AppParser` objects and the `CategoryParser`. I made the wrapper `Iterable` as well for good measure, to imitate the behaviour of `List<AppParser> appParsers`. It looked like this (condensed for convenience):
```java
public class ParserSuite implements Iterable<AppParser> {
    private CategoryParser categoryParser;
    private List<AppParser> appParsers;

    public ParserSuite(EncodingFixer encodingFixer) { ... }
    
    // getCategoryParser(), iterator(), and inner class AppParserIterator<T>
}
```

It seemed perfect! In one fell swoop I can now provide all the dependencies I need, including `EncodingFixer`, to `BodyParser`. In usage, I just had to call `new ParserSuite(encodingFixer)` beforehand. I ran the tests and manually confirmed that the changes worked on an emulator. Confident in my genius, I committed my changes and submitted a pull request.

### Attempt 2: Providing dependencies via constructor, using Dagger
In his review of my pull request, [d4rken](https://github.com/d4rken)  pointed out that AppParserSuite was rather useless - why not just inject the dependencies using [Dagger](https://google.github.io/dagger/), which was already set up in the app, and eliminate the need for an additional wrapper class?

A very good question. Oops. To be honest, I had avoided it because I didn’t understand how it worked. A bit of research remedied that - turns out, Dagger is a very nifty library that (in its simplest form) uses [components](https://google.github.io/dagger/api/2.10/dagger/Component.html), [modules](https://google.github.io/dagger/api/2.10/dagger/Module.html) and various method annotations to provide dependencies without any `new BodyParser(new ParserSuite(new EncodingFixer))` nonsense. This allows service creation to be centralized in an organized manner.

For this particular problem, I opted to add the `@Inject` [annotation](https://docs.oracle.com/javaee/7/api/javax/inject/package-summary.html) to the `BodyParser` constructor, like so:
```java
    @Inject
    public BodyParser(CategoryParser categoryParser, Set<AppParser> appParsers) {
        this.appParsers = appParsers;
        this.categoryParser = categoryParser;
    }
```

This indicates to Dagger that should an instance of `BodyParser` be required, this is the constructor to use. However, I still needed a `CategoryParser` and `Set<AppParser>`, which Dagger could generously provide as well with a few additions to the relevant Dagger module. All I needed was the  `@Provides` [annotation](https://google.github.io/dagger/api/2.10/dagger/Provides.html):
```java
@Module
public class WikiRepositoryModule {
    // some other @Provides methods

    @Provides
    Set<AppParser> provideAppParsers(EncodingFixer encodingFixer) {
        // stuff that ends up returning Set<AppParser>
    }

    @Provides
    CategoryParser provideCategoryParser(EncodingFixer encodingFixer) {
        return new CategoryParser(encodingFixer);
    }

    @Provides
    EncodingFixer provideEncodingFixer() { return new EncodingFixer(); }
}
```

What happens now is when an instance of `BodyParser` is required by a Dagger module, Dagger will use the `@Inject`-annotated constructor to create one. Since said constructor requires  `CategoryParser` and `Set<AppParser>`, it will use the `@Provides` providers you see above to create them. Each of those providers require an `EncodingFixer`, which Dagger will inject using `provideEncodingFixer()`.

With everything set up, I just had to add the `BodyParser` dependency to the provider and constructor of the class that requires it, and my refactoring was complete. I could finally turn my attention back to the reason I began this endeavour in the first place: mocking out `BodyParser`’s dependencies so I could isolate it in testing:
```java
public class BodyParserTest {
    @Mock AppParser appParser;
    @Mock CategoryParser categoryParser;
    private BodyParser bodyParser;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        // the following code sets up our @Mock AppParser and @Mock CategoryParser
        doAnswer(new Answer<Void>() {
            // when you call categoryParser.parse(), return null
            @Override
            public Void answer(InvocationOnMock invocation) throws Throwable {
                return null;
            }
        }).when(categoryParser).parse(isA(AppInfo.class), anyList());
        
        doAnswer(new Answer<Void>() {
            // when you call appParser.parse(), return null
            @Override
            public Void answer(InvocationOnMock invocation) throws Throwable {
                return null;
            }
        }).when(appParser).parse(isA(AppInfo.class), anyMap());

        // set up a set of mocked AppParsers to give to BodyParser
        Set<AppParser> appParsers = new HashSet<>();
        for (int i=0; i<5; i++) {
            appParsers.add(appParser);
        }

        bodyParser = new BodyParser(categoryParser, appParsers);
    }

    @Test
    public void testBodyParser() { ... }
}
```

Tada! Code coverage dropped significantly as a result of these changes - the `AppParser` implementations were no longer being covered by the `BodyParser` test. This was easily remedied by unit tests for each implementation that I submitted later. These changes also made `BodyParser` and the classes that use it a bit more readable, eliminating quite a few constructor calls. 

I’m pretty satisfied with the results and will definitely be using these techniques more often in the future. The changes I made in this pull request can be seen [here](https://github.com/d4rken/reddit-android-appstore/pull/114/files) - unfortunately, a few library updates and changes had to be made as well, so those got included in the pull request - the associated discussion should provide some insight into that. You’ll probably notice that d4rken provided quite a lot of guidance before I finally worked it out - kudos to him! You can also read more about my work on this project [here](/r-android-appstore/).

Thank you to whoever made it this far! Hopefully that wasn’t too boring a read. I’ll keep updating this blog occasionally, if for no reason other than to occasionally help consolidate what I have learned.
