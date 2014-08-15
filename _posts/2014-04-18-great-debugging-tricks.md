---
layout: post
title:  "Great Debugging Tricks"
date:   2014-04-18 17:00:00
author: dan_bernier
---

I normally don't care for sharing slide decks, because so much context is removed, but this one was carefully prepared for virality, and the context-free vacuum of space. It's so good, even without context, because so many slides are terminals.

[Debugging: The Science of Deduction // Speaker Deck](https://speakerdeck.com/daniellesucher/debugging-the-science-of-deduction), from @daniellesucher, via the Ruby Rogues.

Some git forensic tips I learned:

- `git blame -w filename` ignores whitespace commits!
- `git blame -wCCC` detects moved/copied lines! I have to try this.
- `git log -p -S "search string"` lists only commits where "search string" was added or deleted. \o/

Some of my favorite parts:

- "Refactoring or adding tests (or even just fixing typos) keeps you focused and improves your understanding."
  - Martin Fowler reported that Ralph Johnson called that "wiping the dirt off the windows." You'll probably hear me say that at some point.
- "With really gnarly code, write tests to document existing behavior"
- "Wave your hands around in the air, placing pieces of your system in imaginary 3d space"
  - I <3 doing this.
- "If you don't understand the cause of the problem, it's not fixed, because you can't predict when it might come up again."
NB: this doesn't always mean you have to chase a bug to its root. Sometimes it's ok to move on - but be aware that you're on thin ice.

:wq
