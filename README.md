continuitycontrol.github.io
===========================

This is the Tiger Team's blog, in jekyll.

You can read it for realsies at http://engineering.continuity.net/.

Lots more info about blogging w/ jekyll is available from [Jekyll](http://jekyllrb.com/docs/posts/).

## How to Set This Up Locally

1. Clone this repo
2. `cd` into the dir, and `$ bundle install`

## How to Write a Blog Post and Preview It

* Start a file under `/_posts`, named YYYY-MM-DD-your-slug-goes-here.md
* Add a block to the top of the file, like this:

```
---
layout: post
title:  "Great Debugging Tricks"
date:   2014-04-18 17:00:00
post_author: Dan Bernier
---
```

* Write the rest of your post in markdown.
* Preview with: `jekyll serve --port 9001 -w`

## How To Publish

* `git push origin master`

## How to Change the CSS

`vim css/main.css`
