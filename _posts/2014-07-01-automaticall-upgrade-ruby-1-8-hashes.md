---
layout: post
title:  "Automatically Upgrade Ruby 1.8 Hashes"
date:   2014-07-01 09:00:00
author: dan_bernier
---

If you have a code base that started before Ruby 1.9, it probably still has
some 1.8-style hashes hanging around in there.

When nifty new syntax comes out, we start using it on _new_ code, and we
gradually work it into existing code as we make other changes to it, but it's
not always worth the effort to manually update all the code (or worth the risk
to automate it), just for consistency.

This little helper doesn't change those dynamics much, but it _does_ make it
easier to manually yank out your hashrockets.

    map <Leader>9 :.s/:\([_a-z0-9]\{1,}\) *=>/\1:/g<CR>:nohlsearch<CR>

1. Put that in your .vimrc, and reload vim
2. Open a ruby file with a 1.8-style hash
3. Put your cursor on a line with some hashrockets, type `<Leader>9`, and
   you'll have a 1.9-style key-value pair. In our case, that's `,9`. Nice &
   short.

If you have a file with many key-value pairs, you'll have to `<Leader>9` them
line by line. Tedious? Sure, but it's easy to see if the regex screws up.

Because that regular expression isn't perfect! According to [this
gist](https://gist.github.com/misfo/1072693), Ruby symbols can:

* start with `@`, `$`, `_`, or any upper- or lower-case letter
* contain `_`, any upper- or lower-case letter, or any digit
* end with `!`, `_`, `=`, `?`, any upper- or lower-case letter, or any digit

That regular expression looks for a colon followed by at least 1 `_`,
lower-case letter, or number, followed by 0 or more spaces, and a hash rocket.
That covers the majority of our cases, so it's good enough for now.

:wq

