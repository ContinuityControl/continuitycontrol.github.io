---
layout: post
title:  "Between the Law of Demeter and Primitive Obsession"
date:   2014-08-07 15:00:00
author: dan_bernier
---

The Law of Demeter is pretty well-known in modern programming circles.  It's
the one that we think of as "don't have too many dots in one expression."

```
user.department.manager.boss.address.city.name
```

Each of those method calls is an assumption that the code makes about the data
- is one more reason for it to change. One more thing it's dependent on.
This is why it's also called the Principle of Least Knowledge - you don't want
code that knows too much about everything else.

![You see much, line of code. TOO much.](/images/you-see-much.gif)

~ ~ ~

Let's look at some code - the venerable rails Blog example. We want to greet
the author with a special message, to put them in a creative mood.

```ruby
def greet_user(blog)
  "Hello, #{blog.user.name}! You're smart and interesting!"
end
```

If that looks weird, it should. (The logic, I mean, not the encouragement.) Why
does a method that seems to be about a user only accept a user who's chaperoned
by a blog, just to unpack the user out of it?  If we want to greet a user, must
we always find their blog first?

So let's refactor it. Let's pass the user directly:

```ruby
def greet_user(user)
  "Hello, #{user.name}! You're smart and interesting!"
end
```

This is better - our `greet_user` method knows less about how our classes
relate to each other.

Let's move farther in that direction. The first change was good - maybe more
will be better.

```ruby
def greet_user(name)
  "Hello, #{name}! You're smart and interesting!"
end
```

Is this better?

The method name seems wrong now - it takes a name, but it refers to a user.
But we can rename it, so let's not worry about that right now. (Though the fact
itself is suggestive.)

The method knows even less about our class relationships - in fact, it doesn't
know about _any_ of our classes; it only relies on a core Ruby type. So that
should be better, right?

Let's think about this another way. What if, later, we want to provide extra
encouragement to authors who haven't blogged much lately? If `greet_user` takes
a String, we'll have to pass the number of recent blog posts as another
parameter, or revert to passing the user.

This is starting to look like [primitive
obsession](http://sourcemaking.com/refactoring/primitive-obsession): using
primitive, built-in types like Strings and Integers instead objects closer to
your domain. The problem with primitive obsession is that it means you have to
organize all your data yourself - there's no structure to it. There's no clump
of data called a _user_ that holds related data together, that you can think of
as one thing.

[This plays into the Flexibility/Usability trade-off, and how interfaces
are about psychological chunking.]

So: if we pass a large structure, we have to _understand_ the structure to find
what we want. If we pass unstructured data, everything is ad-hoc. (Can you
imagine passing parameters as an array, and finding them by index?)

Objects lend structure to our data. Too much structure is complicated, and too
little is clumsy. If we find the right amout of structure, we




Does this sound like [YAGNI](http://c2.com/cgi/wiki?YouArentGonnaNeedIt)? It
shouldn't. YAGNI says: don't implement a feature until you need it. I'm not
saying we should implement a feature we don't need yet, I'm saying let's
organize the code in a way that lets us change it in the future. Let's not
paint ourselves into a corner.



~ ~ ~

The problem with Primitive Obsession is that it forces you to manage all the
data - like carrying a bunch of apples without a bag, you can only juggle so
many before you need to bag 'em up. (http://mitchhedbergfans.com/post/9665293611/i-went-to-the-store-bought-eight-apples-the-clerk-said-d)

Code obsessed with primitives forces you to manage all the data - to remember
which parameters go together. It's like carrying a bunch of apples without a
bag - you can only carry so many before you need to bag 'em up. Objects group
data together: objects let you bag your data together.

When you pass a User instead of just a name,

But the problem with the Demeter violation is that it tangles us up.



~ ~ ~

My point isn't that you should always pass an object, or an
ActiveRecord::Model, or only access properties from a model, or never pass
primitives.

My point is, think about Demeter and Primitive Obsession like Scylla and
Charybdis, standing on either side of the channel. You don't want your ship
to be too rigid, and crash on the Rock of Demeter, but you don't want to
drown in the whirlpool of primitives, either. Find a way to balance between
the extremes, and know when you're sailing too close to either one.
