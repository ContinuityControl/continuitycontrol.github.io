---
layout: post
title:  "Tactical Refactoring"
date:   2014-10-20 09:30:00
author: dan_bernier
---

# Refactoring Tactics

Refactoring happens in many small steps.

Ever heard this? "This code sucks. We need to refactor." It sounds like they'll
sit down, open the sucky code source files, Refactor The Code, and then they'll
have good code, right? Sucky &rarr; Refactor &rarr; Good. Like a machine.

Refactoring happens in many small steps. A little at a time, over time.

## A Story

We're in the middle of a move from an older-style layout to a newer one: it
looks better, the code is better, and it uses better assets. The old CSS is
written for [formtastic](https://github.com/justinfrench/formtastic), which
we're moving away from; the new CSS works well with
[simple_form](https://github.com/plataformatec/simple_form), which we're
adopting instead.

Also, like most web apps, we have a section of our site reserved for
administrators.  It uses a stripped-down version of the old application layout.

Recently, Alex & I added another controller to the administrators-only section.
We wanted to use the new layout style and simple_form, but we had no layout for
it. We considered writing one, and upgrading the administrator pages to use it,
but that would take much longer than we'd allowed for. In the end, we built the
new section using the old layouts, and it turned out OK.

It's good to notice stumbling blocks like this. When you're about to do the
right thing, and something stops you, you should remove that thing.

## A Post-Script to the Story

A few days later, I went back to the administrator's section with one goal:
make it easy to use the new layout style. I didn't make _any_ of the pages use
it: they're all still on the old layout, even the one we just added. But next
time, we'll [fall into the pit of
success](http://blog.codinghorror.com/falling-into-the-pit-of-success/).

The refactoring was simple:

1. I saved a copy of the admin layout, admin.html.erb, as admin_old.html.erb.
2. I upgraded admin.html.erb to use the new assets. (At this point, all of the
pages looked pretty broken.) 3. All the controllers in this section subclass a
common controller, a kind of [layer
supertype](http://martinfowler.com/eaaCatalog/layerSupertype.html). It
specified `layout 'admin'`, and I kept it that way - but I added `layout
'admin_old'` to each controller that subclassed it.

That's it. Everything works the same as it did before, but the code is
structured in a better way: any new controllers will use the new layout, and we
can upgrade the others piecemeal, when we have spare time.

## Tactical Refactoring

Was that actually a good refactoring? Did I just make things worse, more
confusing?  What if the next developer copy-pastes the `layout 'admin_old'`
part?

Google currently offers this definition of 'tactical' third, after two military
ones:

> (of a person or their actions) showing adroit planning; aiming at an end
> beyond the immediate action.

"Aiming at an end beyond the immediate action." 

When you're working in a codebase with other people, everyone should know about
in-progress refactorings like this. It's hard to understand a tactical action
without knowing the end that it's aiming toward.

On the other hand, don't let these refactorings get out of hand. Try to finish
one before starting another. Consider leaving a big, ugly comment next to the
old code, to help developers notice the odd situation, and as an incentive to
clean it up.

    # Right now, we're migrating to the 'admin' layout.  If you have time,
    # re-write this one! Switch this to `layout 'admin'`, and re-write the
    # views to use simple_form.  If you don't, that's OK, but in the meantime,
    # don't copy-paste this into any new controllers in this section.
    layout 'admin_old'

:wq
