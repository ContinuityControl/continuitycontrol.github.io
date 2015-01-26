---
title:  "Faster Grepping in Vim"
date:   2014-06-16 22:45:00
author: ben_oakes
---

Hat tip to Thoughtbot's article, [Faster Grepping in Vim](http://robots.thoughtbot.com/faster-grepping-in-vim).

> This searches for the text under the cursor and shows the results in a "quickfix" window.

It works well with `git grep` if you have [`fugitive.vim`](https://github.com/tpope/vim-fugitive) installed.

From [our dotfiles](https://github.com/ContinuityControl/dotfiles/commit/299554f378938ff124294c27a1f3cda17a124797):

    nnoremap K :Ggrep "\b<C-R><C-W>\b"<CR>:cw<CR>

Thanks to [Nathan Smith](https://github.com/smith) from Chef for showing it to us!

:wqa
