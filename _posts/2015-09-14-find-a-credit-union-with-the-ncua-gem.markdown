---
title: Find a Credit Union With the NCUA Gem
date: 2015-09-14T15:22:49+00:00
author: tom_reznick
excerpt: The NCUA uses asynchronous JSON requests to find a Credit Union. We make a Gem for that.
---

At Continuity, we write software that helps banks and credit unions complete their federal compliance work. There are quite a few regulators that pertain to banks and credit unions, but perhaps none more significant than the Federal Deposit Insurance Corporation ([FDIC](http://www.fdic.gov/)) and the National Credit Union Administration ([NCUA](http://www.ncua.gov/)).

About a month ago, we [made a gem wrapping the FDIC's unpublished JSON API]({% post_url 2015-08-04-fdic-gem %}).

When we first built this gem, we had hoped that the NCUA would move some of their Credit Union search tools to use JSON asynchronously like the FDIC has. That day as come, and so we've [made another gem that wraps the NCUA's find a credit union tool](https://rubygems.org/gems/ncua).

New JSON API? [We can gem that!](https://www.youtube.com/watch?v=yYey8ntlK_E)[^1]

This is great for us, because it lets us validate client data against regulatory records, and gives us programmatic access to a vast source of public government data.

Here's the [source](https://github.com/ContinuityControl/ncua).

The Gem's `README` provides a good measure of the documentation for its use, but I'll repeat some here to explain some of the design decisions.

The `NCUA` API lets you search for a Credit Union office by name, charter_number, and address.

{% highlight ruby linenos %}
credit_unions = NCUA.find_office_by_name('Federal')
#=> [NCUA::CreditUnion::Office, ...]
credit_unions = NCUA.find_office_by_charter_number(12345)
#=> [NCUA::CreditUnion::Office, ...]
# Note: searching by address takes an optional radius parameter that defines in miles
# the radius of your address query. When omitted, it queries 100 miles by default.
credit_unions = NCUA.find_office_by_address('59 Elm St. New Haven, CT', radius: 50)
#=> [NCUA::CreditUnion::Office, ...]
{% endhighlight %}

Note that the query methods return `NCUA::CreditUnion::Office` objects. The NCUA's [Credit Union Locator](http://www.ncua.gov/NCUAMapping/Pages/NCUAGOVMapping.aspx) searches for credit union offices, which may be specific branches of a Credit Union.

Therefore, you can expect the `charter_number` query to return all of the office locations for a particular credit union.

From any `NCUA::CreditUnion::Office` you can get details of the Credit Union in question:

{% highlight ruby linenos %}
credit_unions = NCUA.find_office_by_charter_number(12345)
#=> [NCUA::CreditUnion::Office, ...]
credit_unions.first.details
#=> NCUA::CreditUnion::Details
{% endhighlight %}

You can also query this directly from the `NCUA` module:

{% highlight ruby linenos %}
NCUA.find_credit_union(charter_number)
#=> NCUA::CreditUnion::Details
{% endhighlight %}

We scrape the data from [this page](http://mapping.ncua.gov/SingleResult.aspx?ID=17057), so there's a good chance that this might blow up. If so, [let us know!](https://github.com/ContinuityControl/ncua/issues/new)

We're working on making this gem better. It needs some good error handling and some way of letting us know when the NCUA's markup changes so we can scrape differently. There's also the option to scrape more data from the NCUA, specifically some of their Financial Performance Reports, but this may not be a direction we want to move towards.

But for now, that's all.

Also first post! w00t!
~~
PRs welcome
:x (because vimgolf)

[^1]: No relation to [python](https://docs.python.org/3.5/library/pickle.html) ¯\\\_(ツ)\_/¯
