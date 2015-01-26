---
title:  "Recipe: git bisect"
date:   2014-04-29 20:43:00
author: ben_oakes
---

Git ships with an awesome, underused utility called `git-bisect`.  I had a bug to track down today that already had a spec, so it was a perfect fit.  Normally our continuous integration (CI) service would have alerted us earlier, but unfortunately the failure was masked by another problem.

## Ingredients

  * 1 executable to test a commit
  * 1 known bad commit (often `HEAD`)
  * 1 known good commit

## Directions

### Prepare the test executable

In this case, I've called it `private/git-bisect.sh` and filled it with this:

    # Don't forget to `chmod +x` this file.
    # You can add more steps here if necessary, e.g. installing dependencies.
    rspec spec/services/my_service_spec.rb

### Find the bad commit

I'm going to assume `HEAD` is a bad commit (meaning that the test executable fails).

### Find a good commit

Go back a reasonable amount of time (e.g. make an educated guess, like 1 month) and find a commit that doesn't fail the test executable.

### Bisect!

After you have your good commit, just run a set of commands and `git bisect` will track down the source of the problem for you:

    bad_commit=HEAD
    good_commit=fbb3823
    git bisect start $bad_commit $good_commit
    git bisect run private/git-bisect.sh

Eventually, it will have bisected back to the source of the problem, producing output like this:

    3f23680fefb5302c780ccc68b5d3006e9f37dd92 is the first bad commit
    commit 3f23680fefb5302c780ccc68b5d3006e9f37dd92
    Author: He Who Shall Not Be Named <voldemort@example.com>
    Date:   Wed Apr 23 11:40:48 2014 -0400

        just change something small, no big deal... honest!

    :040000 040000 088559324ff27ec7be6967e8c50934a9837b8f55 e7f89bede815904bb79d5b01807e4e01c8378f14 M      app
    bisect run success

That first line identifies SHA `3f23680fefb5302c780ccc68b5d3006e9f37dd92` as the source of the problem, which was right in my case.  Yay for automation!

### Clean up

Now that I'm all done, I can:

    git bisect reset

Git cleans up, and puts me back where I started.

### Investigate

Normally just running `git show $first_bad_commit` will reveal something useful. Tracking down the problem depends on the situation, of course.  (Keep in mind that the "first bad commit" might not be the one you're looking for.)

Good hunting!

## Resources

* `man git-bisect`
* [Git bisect saves the day](http://blog.boombatower.com/git-bisect-saves-the-day)

:wq
