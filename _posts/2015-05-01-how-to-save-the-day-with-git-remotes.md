---
title: How to Save the Day with Git Remotes
date:   2015-05-01 21:06:00
author: ben_oakes
excerpt: Adding another remote is a good option to get you out of a bind.
---

Can't push commits to GitHub, but need to move them to another clone?  Adding another remote is a good option to get you out of a bind.

## Why did this come up?

We do a lot of pair programming at Continuity.  One of the great things about it is that if someone is out sick, you can usually depend on the other person to know the details of what was happening.  But what if both people are out sick and they forgot to push their branch to GitHub and the deadline is today?

(That happened last week!)

The solution described in this post is a little specific to how we pair program remotely.  Our team is almost 50% remote developers, and we all share access to the same EC2 instance.  We use `wemux` and `vim` to pair (among other tools), and the provisioning is automated by `puppet`.

Back to the tale of the missing pair, one idea that came up was installing another SSH key to the missing person's `~/.ssh/authorized_keys`, but that has a number of problems:

  * That makes their account a shared account.  Because you can't tell who was using it, if someone did something bad using the account, you can't easily tell who did it.
  * If the key is added by `puppet` (as it should be), that adds a lot of labor just to add a temporary key.
  * You still can't push any commits to GitHub without also installing the key there.

Finally, installing keys on another user's account just *feels* like a practice to avoid, if no other reason.

Instead, what we decided to do was to become their user via `sudo` (which is logged) and then push to a local clone of the git repository.  That might sound complicated if you've only ever used `git` in combination with GitHub, but it's actually a lot simpler than you'd think.

## The Plan

What we're going to do is push the absent user's code to a shared directory, then pull it to your clone of the repository.

We'll refer to the absent user as `them` and the user that needs access to the code as `you`.

## How to

Just to set the stage, let's look at the normal remotes for a clone from GitHub:

    them$ git remote -v
    origin  git@github.com:your-organization/your-repo.git (fetch)
    origin  git@github.com:your-organization/your-repo.git (push)

What we're going to do is make a remote on the local filesystem.

We'll start by cloning into a shared directory (`/tmp` in this case):

    them$ mkdir -p /tmp/git
    them$ cd /tmp/git
    them$ git clone git@github.com:your-organization/your-repo.git

We know that the absent user has a branch with code you need:

    them$ git branch
      master
      develop
    * feature/lol-i-will-be-here-tomorrow

So we'll push it to that repo on the local filesystem:

    them$ git remote add my-awesome-local-git-repo /tmp/git/your-repo/.git
    them$ git remote -v
    my-awesome-local-git-repo       /tmp/git/your-repo/.git (fetch)
    my-awesome-local-git-repo       /tmp/git/your-repo/.git (push)
    origin  git@github.com:your-organization/your-repo.git (fetch)
    origin  git@github.com:your-organization/your-repo.git (push)

Then you can go back to your user account and pull it.

But first, you'll need to make sure the `/tmp/git/your-repo` files are accessible.  Since it's a temporary clone, you could do something like this:

    you$ sudo chown -R you:you .

And then go back your clone, add the remote, and check out the branch:

    you$ git remote add my-awesome-local-git-repo /tmp/git/your-repo/.git
    you$ git fetch my-awesome-local-git-repo
    you$ git co feature/lol-i-will-be-here-tomorrow

And there's the branch you needed!  We're all done in our scenario, so you could now `rm -rf /tmp/git`.

## Summary

Git allows you to do a lot of interesting things like have a remote on the local filesystem, as described above:

    $ git remote add my-awesome-local-git-repo /tmp/git/your-repo/.git

The remote on the local filesystem acts just like any other remote; it just happens to be hosted locally.  There's very little magic going on!  It's just a pile of files that `git` manages.

Another useful type of remote you can make yourself is a clone on another machine that's accessible over SSH (and has the required `git` executables in `$PATH`):

    $ git remote add my-awesome-remote-git-repo ssh://your-server/path/to/your-repo.git

That's a lot like a private GitHub repo, but without any of the pretty web user interface or authorization management.

I hope this example helps illustrate that `git` is very flexible and can bend to your needs.  If you've only ever used GitHub as a remote when using `git`, you're missing out on some useful functionality!  However, it's  it's still best to have all your code in a central location, even though you could add a thousand remotes.  Like any tool, know when to use it!
