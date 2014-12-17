---
layout: post
title:  "[DRAFT] Thinking at the Object Level"
date:   2014-12-25 23:30:00
author: dan_bernier
---

> Always design a thing by considering it in its next larger context - a chair in a room, a room in a house, a house in an environment, an environment in a city plan.  - Eliel Saarinen

It's important to write good methods: short, not too many arguments, one level of abstraction.

But it's even more important to get the boundaries and relationships between your objects right.

If music is the space between the notes, then object design is the space between the objects.

# Why Is The Object Level Important?

How often has this happened: you have to add some feature to some part of your rails app. You open the controller, open the view, and let's say there's a presenter involved, so you open that, too. You add the method to the presenter, call it from the view, and you're done. This works well for a while, but after a while, your presenter is HUGE. What happened? I think what happened is that you're not thinking about your code structure at the object level: you're taking the object structure for granted. Controller-Model-Presenter-View, and the View only calls methods in the Presenter.

You know how you decompose code into methods, and you worry whether this bit should go in _this_ method, or in _that_ one? How often do you worry which class the method should go in?

Boundaries between objects are like a buffer, a firewall, a blast containment room. They're the walls of the isolation ward - they (help) keep problems with one object from infecting another.

If your object structure is right, but your internal methods are crap, you can improve. It's easier to fine-tune private methods once your structure is right: if a good structure is roughed out, you can iron out wrinkles, refactor methods; tests are easier to write for an object that has clear boundaries and responsibilities. 

But if you can only work at the method level, you'll usually add methods to existing classes, and your classes will get bigger. When they're too big for comfort, you won't know how to break them apart.

# So, How Do We Do This, Then?

How do we break our applications, our problems, into objects to do the work for us?

There are lots of ways to approach this. (There are lots of heavy books you can buy.) But a few simple, strong ideas, loosely held, should serve.

One of those simple ideas is to organize your objects around responsibilities.

Object-oriented programming is about breaking a problem into tasks that can be carried out by objects working together. It's more like divvying up work that we think: one person collects the dishes, another washes them, a third dries them, and a fourth puts them away. Each person has their job, their role, their responsibility, and to make it work correctly, you need to carefully manage how the dishes move from one person to the next.

Responsibility-Driven Design focuses on defining those responsibilities, and creating objects to fulfill them.

That sounds a bit abstract, and the RDD books offer a lot of suggestions for how you actually DO this, but the most useful part of it is that idea that you can anthropomorphize your objects. Once you start thinking about breaking the work up, and having objects that can do one thing that other objects need, the objects become a little easier to see. As Rebecca Wirfs-Brock says in "Designing Object-Oriented Software," "Finding or creating these objects is a problem of structuring knowledge and activities. [Object-oriented programming's] goals are to find the objects and their connections."

It's about figuring out who does what, and how they work together.


-----------------

It's a basic idea: design your objects around responsibilities, jobs that have to be done.

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
