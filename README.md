continuitycontrol.github.io
===========================

This is the Tiger Team's blog, in jekyll.

You can read it for realsies at http://engineering.continuity.net/.

Lots more info about blogging w/ jekyll is available from [Jekyll](http://jekyllrb.com/docs/posts/).

## How to Set This Up Locally

1. Clone this repo
2. `cd` into the dir, and `$ bundle install`

## One Time Setup

* Add yourself to `_data/authors.yml`
* Add your head-in-a-jar avatar to the `images` directory
  * To get this from gravatar
    * `require 'digest'; puts "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(shared_email.downcase)}?s=200"`
    * For more information: https://en.gravatar.com/site/implement/images/

## Full Cycle Blog Posting

* Create your draft: `octopress new draft 'Your title goes here'`
* Open your file in `_drafts/your-title-goes-here.md`
* Write your post in md
* Preview with: `jekyll serve --drafts --host 0.0.0.0 --port YOUR_PORT --watch`
* Publish with: `octopress publish _drafts/your-title-goes-here.md`
* Commit and push

## Posting via Prose.io

* go to prose.io
* login with your github account (probably with access to public repos only)
* make a new `.md` file in `_drafts`, save as often as you'd like
* preview toggle / publish using their buttons

## How to Change the CSS

`vim css/main.css`
