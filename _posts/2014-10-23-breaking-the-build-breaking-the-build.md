---
title: "Breaking the Build. Breaking the Build."
date: 2014-10-23T20:22:34+00:00
author: zach_morek
modified:
categories:
excerpt: Compile your assets before your feature specs to avoid timeouts!
tags: []
image:
  feature:
---

## TL; DR

Compile your assets before your feature specs to avoid timeouts!

## Breaking the law, breaking the law

![Breaking the law!](/images/breaking_the_law.gif)

For too long we had a breaking build. It felt pretty terrible. Our feature specs kept timing out, and we could only rely on our test suite to fail when the build was really broken. Needless to say this was frustrating. We were breaking our own law, and were feeling the pain of it.

We weren't the only people with this problem. The `Poltergeist::TimeoutError` message snippet has a very active issues ticket open on GitHub.

     Capybara::Poltergeist::TimeoutError: Timed out waiting for response to
     {"name":"visit","args":["http://127.0.0.1:49692/stuff"]}.

     It's possible that this happened because something took a very long time
     (for example a page load was slow). If so, setting the Poltergeist
     :timeout option to a higher value will help (see the docs for details). If
     increasing the timeout does not help, this is probably a bug in
     Poltergeist - please report it to the issue tracker.

[Capybara::Poltergeist::TimeoutError · Issue #375 · teampoltergeist/poltergeist](https://github.com/teampoltergeist/poltergeist/issues/375)

All the posted solutions seemed to provide no real help. We tried removing all external JavaScript references, we tightened up all ajax calls with `page.has_content?('text on page to wait for')`, but we couldn't get all of our specs reliably running. Each time we tried something we'd get excited that the build would pass, and then a flickering spec would fail again, and we couldn't replicate it in our development environment.

![First I was like the build's gonna pass! Then I was like nope.](/images/kanye_smile_frown.gif)

It suddenly dawned on us that we have a lot of JavaScript in our application, and our test suite was compiling JavaScript. The suite wasn't waiting long enough for the specs to compile and would give up before the page even had a chance. We tried compiling our JavaScript then running our specs and suddenly it started working!

We identified a number of places where we could compile the JavaScript. We tried making calls to Rails core objects that compile, we tried shelling out in a `before(:all)` block, we tried invoking the rake task via the `Rake` object, and a few other solutions. Ultimately we decided that in order to keep our spec suite lean on our local development machines, we would only compile our assets in our build scripts that set up our environment for our build system.

Now our suite is reliably green and totally rad.

![Yeaaaaah!](/images/thumbs_up_andy.gif)

:wq
