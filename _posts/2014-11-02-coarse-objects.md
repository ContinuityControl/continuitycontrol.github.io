---
layout: post
title:  "[DRAFT] Coarse Objects"
date:   2014-11-02 14:00:00
author: dan_bernier
---

> Always design a thing by considering it in its next larger context - a chair in a room, a room in a house, a house in an environment, an environment in a city plan.  - Eliel Saarinen

It's important to write good methods: short, not too many arguments, one level of abstraction.

But it's even more important to get the boundaries and relationships between your objects right.

If music is the space between the notes, then object design is the space between the objects.

# Why Is The Object Level Important?

How often has this happened: you have to add some feature to some part of your rails app. You open the controller, open the view, and let's say there's a presenter involved, so you open that, too. You add the method to the presenter, call it from the view, and you're done. This works well for a while, but after a while, your presenter is HUGE. What happened? I think what happened is that you're not thinking about your code structure at the object level: you're taking the object structure for granted. Controller-Model-Presenter-View, and the View only calls methods in the Presenter.

You know how you decompose code into methods, and you worry whether this bit should go in _this_ method, or in _that_ one? How often do you worry which class the method should go in?

If your object structure is right, but your internal methods are crap, you can improve. It's easier to fine-tune private methods once your structure is right: if a good structure is roughed out, you can iron out wrinkles, refactor methods; tests are easier to write for an object that has clear boundaries and responsibilities. 

But if you can only work at the method level, you'll usually add methods to existing classes, and your classes will get bigger. When they're too big for comfort, you won't know how to break them apart.

# So, How Do We Do This, Then?

How do we break our apps, our problems, into objects to do the work for us?

This used to be a pretty common theme of software books, back in the 90's and 2000's. 

There are a few schools of thought. Two big ones are Domain-Driven Design, where, loosely, your Domain Model is a bunch of classes that represent some of the big nouns in your application's Domain. It provides a raft of other patterns, like Repository, Identity Mapper, and Unit of Work, to support the actual application part.

An approach that used to be common was to throw as many Gang-of-Four Design Patterns at your app as you could. I don't recommend this approach. It DOES, however, teach you a lot of patterns along the way, and a programmer studying design patterns is like an architect visiting Rome or Greece, or an author reading a novel.

## Responsibility-Driven Design

Another approach that I've found really useful is responsibility-driven design. It's a basic idea: design objects around responsibilities, jobs that have to be done.

First, some quotes! One from Rebecca Wirfs-Brock:

> The object-oriented approach attempts to manage the complexity inherent in
> real-world problems by abstracting out knowledge, and encapsulating it within
> _objects_. Finding or creating these objects is a problem of structuring
> knowledge and activities.
>
> [Object-oriented programming's] goals are to find the objects and their
connections.
>
> Object-oriented design decomposes a system into entities that know how to
> play their roles within the system. ...
>
> ...when thinking about a software design in object-oriented terms,
> anthropomorphism can be an aid to conceptualization.
> Object-oriented design encourages a view of the world as a system of
> cooperating and collaborating agents. Work is accomplished in an
> object-oriented system by one object sending a request to another to perform
> one of its operations, reveal some of its information, or both. This first
> request then starts a long complex chain of such requests.
> -Designing Object-Oriented Software, Rebecca Wirfs-Brock, pp 5-7

And finally, from Kent Beck and Ward Cunningham, while introducing CRCs:

> The most difficult problem in teaching object-oriented programming is
> getting the learner to give up the global knowledge of control that is
> possible with procedural programs, and rely on the local knowledge of objects
> to accomplish their tasks. Novice designs are littered with regressions to
> global thinking: gratuitous global variables, unnecessary pointers, and
> inappropriate reliance on the implementation of other objects.

> ...Responsibilities identify problems to be solved. The solutions will exist in
> many versions and refinements. A responsibility serves as a handle for
> discussing potential solutions. The responsibilities of an object are
> expressed by a handful of short verb phrases, each containing an active verb.
> The more that can be expressed by these phrases, the more powerful and
> concise the design. Again, searching for just the right words is a valuable
> use of time while designing.

> One of the distinguishing features of object design is that no object is an
> island. All objects stand in relationship to others, on whom they rely for
> services and control. The last dimension we use in characterizing object
> designs is the collaborators of an object. We name as collaborators objects
> which will send or be sent messages in the course of satisfying
> responsibilities.
- Beck and Cunningham, http://c2.com/doc/oopsla89/paper.html  

This is a pretty anthropomorphic approach. I often find myself acting out interactions between objects.

If you can break a task apart into smaller, independent parts, then you can code an objects to handle each of the parts, and they can send messages to each other to coordinate their efforts.

The best part about this technique is that lots of real-world interactions we have will serve as analogies. 

* the 'coat-check' system, where you hold onto a ticket, and exchange it later for something you want
* Gregor Hohpe's [Starbucks Does Not Use Two-Phase Commit](http://www.eaipatterns.com/ramblings/18_starbucks.html)

By simulating real-world interactions, you can get into the role, and really feel the interaction. This helps you _feel_ what the objects are doing, and clarifies their roles and responsibilities.

## Some Familiar Examples of Thinking at the Object Level

The Null Object pattern is a good example. It shows how to fix a problem - lots of similar nil checks - by adding a new kind of object, just for the nil cases.

Presenters are another object-level pattern, one that shows how to keep view-specific logic out of your views AND your models.

Patterns are still kind of taboo in the Ruby community, even after Russ Olsen's very good book on them. They're part of the baby that was in the Java-bathwater we hastily threw out. Which is a shame, because there's good stuff in there.

## Some Less-Familiar Examples of Thinking at the Object Level

### The Composite Pattern

Talk about Appendix A & B, and recursion. Or, maybe this is the visitor pattern? Think about it.

### The Template Pattern

I don't like the template pattern much, because it requires a lot of shared knowledge between the subclass and the baseclass. I find the strategy pattern to be a

# Don't We Do This Already?

What about DRY? Demeter? SOLID? Don't we talk a lot about object design?

It's true that these are concepts most ruby programmers know about.

But they're principles, not patterns or design strategies. They won't help you design things, but they WILL tell you how you've done. Designing only by these principles is like flying by instruments - you can do it, but if you don't have to, why bother?

# Why Don't We Do This Already?

It's not that we don't talk about object structure or classes that much - we do - but it's easy for a new programmer to just focus on the method-level stuff. Flog and CodeClimate work at that level. Blog posts often talk about methods - maybe because it's easy to embed a short bit of code into a blog post. To talk about object-level design, you'd need a lot more code. Maybe we need a more-compact language for talking about objects and classes, and their relationships to each other. Maybe we should take another look at UML.

(I think we talk about it less now partly because Rails is so opinionated: if there's one right way to do it, you don't have to figure anything out.)

TDD is another reason we talk about this less. TDD is almost an un-technique: rather than design your objects, Test-Driven Design says write a test, make it pass, refactor the code, and then do it again. Keep doing that until your app is done. The tests will keep you honest, while the refactoring steps will let your object structure emerge.
