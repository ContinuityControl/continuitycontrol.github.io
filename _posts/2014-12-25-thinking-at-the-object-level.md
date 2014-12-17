---
layout: post
title:  "[DRAFT] Thinking at the Object Level"
date:   2014-12-25 23:30:00
author: dan_bernier
---

> Always design a thing by considering it in its next larger context - a chair in a room, a room in a house, a house in an environment, an environment in a city plan.  - Eliel Saarinen

You have to design your objects well. Good methods are important, but organizing your objects, and how they work together, is even more important.

If you have large classes, at least part of the problem is you're not breaking them down enough. Maybe, when you add a feature, you're only thinking: which of my existing classes should I add this to? Maybe you should be thinking: does this feature introduce a new job that has to be done? Or, did this tiny responsibility just become complicated enough that it can better be handled by two cooperating objects?

A related problem is when you have multiple objects, but you can't understand how they cooperate. Instead of clear, visible lines of effect, the flow of execution seems to loop on itself.

# But How?

So, now you're convinced: you need to split up your god-objects into smaller well-coordinated teams of objects. How do we do this?

## Look for Responsibilities

Responsibility-Driven Design is a whole school of OO thought that says to organize your objects around responsibilities: every object should have a job to do, and the patterns of cooperation should be clear. This is similar to the Single-Responsibility principle. If a responsibility is coherent, it'll probably need less data from other classes.

CRC cards are a good way to physically model Classes, their Responsibilities, and their Collaborators.

Anthropomorphism always helps, too: don't be shy, get up and play-act the interaction with your pair! It has a way of cementing your understanding of the interaction.

## If We Can't Find Responsibilities?

### Study

Rands said that [a great tool or idea inspires you to build](http://randsinrepose.com/archives/the-forums/) - that's why his dad would wander around the local hardware store. Design Patterns and other programming languages are both great places to wander around looking for ideas.

The original [Gang-of-Four book on Design Patterns](http://en.wikipedia.org/wiki/Design_Patterns) lists 11 patterns that "categorize the ways in which classes or objects interact and distribute responsibility."[^1] 

Tom Stuart's recent post [Refactoring Ruby with Monads](http://codon.com/refactoring-ruby-with-monads) is a great example of poaching ideas from other languages: it uses Monads, a feature from Haskell, a statically-typed pure functional language, to solve some a few difficult problems in Ruby, a dynamically-typed imperative object-oriented language. 

[^1]: Chain of Responsibility, Command, Interpreter, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, and Visitor.

### Map the Terrain

WEwLC has tons of advice for this.
* draw effect sketches and feature sketches
* look for Pinch points

# How Do We Know We Got It Right?

Just like small methods are a good sign, small classes are, too. (Yes, we know this.)

Another good sign is that the pattern of cooperation between the objects is clear: you can explain it, it's evident from the code, and you know which objects know about what.


(Many extremely well-respected OO people say they write odd OO code, because they use immutable objects, instead of relying on side-effects. [Gary Bernhardt](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell), [Joshua Bloch](http://www.javaworld.com/article/2072958/immutable-java-objects.html), [Martin Fowler](http://devchat.tv/ruby-rogues/178-rr-book-club-refactoring-ruby-with-martin-fowler) all 
http://www.amazon.com/Little-Java-Few-Patterns/dp/0262561158



Links i've been looking at:
http://cube-drone.com/2014_11_27-103_Pipes.html
https://www.google.com/search?q=rich+hickey+java+final&oq=rich+hickey+java+final+&aqs=chrome..69i57.3747j0j7&client=ubuntu&sourceid=chrome&es_sm=93&ie=UTF-8
http://www.ibm.com/developerworks/library/j-ft4/
http://www.quora.com/Can-the-concepts-used-by-Rich-Hickey-for-the-Clojure-programming-language-be-modified-to-fit-the-Object-Oriented-paradigm
http://blog.jayfields.com/2014/12/working-effectively-with-unit-tests.html
https://leanpub.com/wewut
http://jaoo.dk/dl/jaoo-aarhus-2009/slides/MichaelFeathers_WorkingEffectivelyWithLegacyCode2.pdf
http://www.schneems.com/post/22192005006/legacy-concerns-in-rails/
https://michaelfeathers.silvrback.com/detecting-shoved-code
