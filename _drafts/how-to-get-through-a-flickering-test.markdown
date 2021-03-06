---
title: How to Get Through a Flickering Test
author: zach_and_casey
modified:
categories:
excerpt: "Flickering Green - How to cope with flickering spec failures"
tags: []
image:
  feature:
---

# Red, Green, Red Again? WTF
![Red light! ..... green light!](/images/stoplight.gif)

A "flickering" spec is one that seemingly randomly passes on some runs of the spec and fails on others. It's a non-deterministic test, usually from a race condition - the "winner" of the race isn't "determined" ahead of time. Sometimes it occurs when an AJAX call from the client to the server is taking time to respond. Sometimes it occurs when a job is queued in the background and it doesn’t execute in time. Sometimes it occurs from a race condition on the javascript event loop directly, where maybe we should be using callbacks.

Non-deterministic tests can take a lot of time and effort to fix, since it can take many runs of the spec to figure out whether you've fixed the situation. Sometimes we may need to punt on fixing a flickering spec immediately, but we really shouldn't settle for an erratically-red build.

Capybara is the most popular ruby testing library used to automate interaction with the site in-browser. Capybara can cleverly figure out what page-rendering details to wait for in most cases, and you [don't normally have to use `wait_until` in Capybara](http://www.elabs.se/blog/53-why-wait_until-was-removed-from-capybara) either.


Our example: background tasks have to run and they take longer than the timeout?
Related Flickering Techniques
Capybara can wait for AJAX `page.has_content? 'Text that shows up after ajax call'` and `page.has_no_content? 'Text that goes off screen after ajax call success'`.
The timeout for that is set to a reasonable default, and we don't want to increase this every single time. This is where our tests start to flicker. We can sometimes extend the timeout by doing

{% highlight ruby linenos %}
using_wait_time(10) do
  do_some_really_slow_thing_here
  page.has_content? 'Slow thing has finished'
end
{% endhighlight %}

Other related solutions (mostly let's just mention & link to these - no more than a sentence or two~)
Sometimes (wait_for_ajax thoughtbot blog post) can help
Sometimes (wait_for_seconds thing) can help
Other remaining problem
Sometimes you just wanna:
flag them so you keep track of which ones are flickering or not (in the first place, regardless of other things)
run them separately from other specs, so you can know whether “non-flickering” specs work or not
run them multiple times on each CI run
if it passes any of the times, allow it to pass through (and of course you wanna fix them)

Our solution!

# A spec that bums us out hard
`spec/flickering_spec.rb`
{% highlight ruby linenos %}
require 'spec_helper'

describe 'Flickering specs tagged with flickering: true' do
  it 'will run by itself on travis', flickering: true do
    # We all get specs with race conditions that we don't have time to fix but still need to trust our build
    race_condition = [:too_fast, :made_it].sample
    expect(race_condition).to eq(:made_it)
  end
end
{% endhighlight %}

# Flickering Spec Re-runner
Run and re-run the specs that are flickering. If they fail 10 times, then they really need to be fixed.
`script/ci/flickering_specs`
{% highlight bash linenos %}
#!/bin/sh
for i in {1..10}
do
  echo "Flickering Specs run-through number: $i"
  bundle exec rspec ./spec --tag @flickering:true
  # if one run-through passes
  if [ $? -eq 0 ]; then
    exit 0
  fi
done

exit 1
{% endhighlight %}

# Non Flickering Specs
Isolate the running specs that are not flickering and stable green.
`script/ci/non_flickering_specs`
{% highlight bash linenos %}
bundle exec rspec ./spec --tag ~@flickering:true
{% endhighlight %}

# Isolating it to run as a separate spec
Configure travis so that the two sets of specs can run separately.
`.travis.yml`
{% highlight bash linenos %}
script: "${TEST_SCRIPT}"
env:
  matrix:
    - TEST_SCRIPT=./script/ci/non_flickering_specs.sh
    - TEST_SCRIPT=./script/ci/flickering_specs.sh
#...
{% endhighlight %}


---

# BONUS SPEC SUITE SPEEDUP!
We run use pivotal tracker and git-flow http://nvie.com/posts/a-successful-git-branching-model/ and name all of our branches with the pivotal card, which means when we do a hotfix, we have 3 branches running (master, develop, and the hotfix tag). This skips the hotfix-tag from running at all.
`.travis.yml`
{% highlight yaml linenos %}
branches:
  except:
    - /^[0-9]/
#...
{% endhighlight %}

---

# BONUS Pivotal Bookmarklet For Branch Names!
{% highlight javascript %}
javascript:(function(){ function slugify(text) { return text.toString().toLowerCase() .replace(/\s+/g, '-') .replace(/[^\w\-]+/g, '') .replace(/\-\-+/g, '-') .replace(/^-+/, '') .replace(/-+$/, ''); } try{ id = $('.edit.details').find('input.id')[0].value; ticket_title = $('.edit.details').find('[name="story[name]"]')[0].innerHTML; slug = slugify(id + "-" + ticket_title); prompt("Here is your slugified title for the first opened pivotal card.",slug); } catch(e){ alert("You are not on a pivotal page with a ticket open.") }})();
{% endhighlight %}
