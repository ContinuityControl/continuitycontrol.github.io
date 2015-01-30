---
title: Fractal Design Improvements / Gradual Elaboration
author: dan_bernier
excerpt: Grow your design gradually. Don't start with a huge foundation.
---

![Candy bar evolution.](/images/candybar-evolution.png)

([via](http://scandybars.tumblr.com/))

When we have too much logic in our views, we extract presenters. When we have too much query logic in our presenters, we extract query objects.

-------------

I just finished a satisfying refactoring. The code is cleaner, its intent is clearer, and - maybe best of all - I feel like I really _understand_ things now. This new structure is so much better than the old mess, that I'd like to convince my team to adopt it as the new official team standard. Without this pattern, the code will grow unrestrained, and we'll just have to clean it out later; why let that happen? Why not just start with all the structure it'll eventually need?

This is actually a bad idea.

We don't actually have to do that.

-----------

Last week, Tom & I started a [tactical refactoring](/tactical-refactoring) to extract a query object from a presenter that had grown a little bloated.

Every weekday morning at Continuity, we send our users a daily digest of all the ToDo's they've been assigned. On Fridays, it's a weekly-recap version, with more information. A cronjob finds users with new assignments, and queues a [delayed job](https://rubygems.org/gems/delayed_job) for each one. The delayed job kicks off a mailer to send the message, but most of the detailed querying and view logic is in a presenter, so it can be unit-tested.

We should've noticed when we first unit tested the presenter that the query logic and view logic are complected[^complect], because we were testing the query logic by examing the properties of the objects that were returned, not their identity: we _couldn't_ test their identity, because they were turned into simple [data transfer objects](https://en.wikipedia.org/wiki/Data_transfer_object)[^dto].

[^complect]: [wordnik](https://www.wordnik.com/words/complect) defines "complect" as: "To join by weaving or twining together; interweave." Rich Hickey introduced the word to mainstream programming in his talk, [Simple Made Easy](http://engineering.continuity.net/), to clarify

[^dto]: Ok, we could've put the ID into the data transfer object, but it would only be there for the tests.

## TODO: Extracting a Query Object makes Testing Easier

So we [extracted a class](http://refactoring.com/catalog/extractClass.html)

## TODO: It also makes the Presenter Simpler

## TODO: Tie-off: yeah, so, tactical. One method & a Big Ugly Comment.

## TODO: So this is pretty good! Why not START with query objects?

* it's ok to grow
* you don't NEED all that weight at the beginning
  * it obscures what you're doing
  * YAGNI
  * when you need it, you can add it

:wq
