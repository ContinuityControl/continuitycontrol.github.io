---
title:  "Thinking with Types: Value Objects"
date:   2014-11-12 10:00:00
author: dan_bernier
---

Sometimes it's useful to raise your thinking from the method-level to the object-level. Value Objects are an easy way to practice this.

## A Motivating Example

A couple weeks ago, a bunch of our [delayed jobs](https://github.com/collectiveidea/delayed_job/) were failing with the same error message:

> Couldn't delete record id='91053', slug='e31d7444-6ae9-d0e2-89a9-8c25ed7c10a4'

There were other jobs failing with different error messages, and it was hard to tell which errors were happening the most -- we have a queue monitor page, but you have to click into each job to see its error message.

So I hacked a little rails-console method to scrub UUIDs and IDs out of strings. Then I plucked out each job's `last_error`, mapped it through the UUID/ID scrubber, dropped all but the first line. With the IDs and UUIDs gone, similar error messages became identical, and we were able to just [count them up](http://www.benjaminoakes.com/2014/01/24/count_by-in-ruby/).

To save us the trouble of doing this again in the future, I added it to the top of the queue monitor page:

|**Error Message**|**Count**|
|Couldn't delete record id='ID', slug='UUID'|290|
|Undefined method :foo on nil:NilClass|11|

I unceremoniously pasted the ID-and-UUID-scrubber code into the controller, as private methods. The controller action created an instance variable: a hash that mapped error messages to their count. (That hash instance variable is still there, waiting for another refactoring.) It looked about like this:

```ruby
def index
  @error_counts = Delayed::Job.where.not(last_error: nil).
    pluck(:last_error).
    map { |error| first_line(scrub_uuids_and_ids(error)) }.
    group_by { |x| x }.map { |x, xs| [x, xs.size] }.
    sort_by { |error, count| -count }
  ...
end

private

def first_line(error)
  error.split("\n").first.truncate(100)
end

def scrub_uuids_and_ids(error)
  error.
    gsub(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/, 'UUID').
    gsub(/\d{3,}/, 'ID')
end
```

Pretty ordinary.

## Value Objects as Types

We programmers write a lot of code that manipulates data. It's what we do. Take some data, pass it to this method, and hand off the result. Those methods, `first_line` and `scrub_uuids_and_ids`, are good examples. Data in, data out.

But sometimes, instead of thinking about the data transformation, it can help to think about the type of data it creates, and to think of it as a new _type_ of data. A new type that's based on the old one, but is distinct in some way. The [value object pattern](http://martinfowler.com/bliki/ValueObject.html) is useful here.

In this case, what I wanted was a generalized error message. I wanted a String that knew it was an error message, and could tell whether it was the same as another error message. If I had string-ish objects like that, I wouldn't need those `first_line` and `scrub_uuids_and_ids` methods in the controller. But I'd also want these string-ish objects to look like any other String, to the rest of Ruby. I could subclass String, but subclasses of Ruby's core classes often do surprising things[^1]. 

Fortunately, if an object implements `to_s` and `to_str`, it'll look like a String, and if it implements `==`, `eql?`, and `hash`, it can decide whether it's equivalent to another object. How and why that works is its own tale, and I'll tell it later.

So, for the error messages, I made a GeneralizedErrorMessage class, and it's initialized with an error message. I gave it a `to_s` method that calls the ID and UUID scrubber methods; I aliased `to_s` as `to_str`. I made `==`, `eql?`, and `hash` methods that delegate to the String returned by `to_s`. So `to_s` is really the crux of this object. 

Here's the full code:

```ruby
class GeneralizedErrorMessage
  def initialize(error_message)
    @error_message = error_message
  end

  def to_s
    first_line(scrub_uuids_and_ids(@error_message))    
  end
  alias :to_s :to_str

  def ==(other)
    self.to_s == other.to_s
  end
  alias :eql? :==

  def hash
    self.to_s.hash
  end

  private 

  def first_line(error)
    error.split("\n").first.truncate(100)
  end

  def scrub_uuids_and_ids(error)
    error.
      gsub(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/, '{{uuid}}').
      gsub(/\d{3,}/, '{{id}}')
  end
end
```

The diff for the controller has a bunch of red, from deleting the private helper methods, and the action method looks like this:

     def index
       @error_counts = Delayed::Job.where.not(last_error: nil).
         pluck(:last_error).
    -   map { |error| first_line(scrub_uuids_and_ids(error)) }.
    +   map { |error| GeneralizedErrorMessage.new(error) }.
         group_by { |x| x }.map { |x, xs| [x, xs.size] }.
         sort_by { |error, count| -count }
       ...
     end

## Did It Help?

There are a few reasons I think this is an improvement.

*It's easier to test.* Now that it's in this class, the code is much easier to spec than it was when it was on the queue monitor page. The specs are pure ruby, so they're fast. Any bugs in there will be easier to fix, because the code is in a test harness.

*It's easier to re-use.* We don't show aggregate error message statistics in many places, but if we ever need to, it'll be trivial. That wasn't intentional -- and you shouldn't build for flexibility you might need later, because [You Aren't Gonna Need It](http://c2.com/cgi/wiki?YouArentGonnaNeedIt) -- but if your design naturally makes re-use easier, that's a good sign. This class isn't dependent on, or embedded in, any part of the application.

*It's a good example.* When we have another situation that could be handled like this, we'll have prior art to look to.

There's one more reason, a subjective one. Categorization is a way to deal with complexity. Thinking in types is a form of categorization. By giving a name to this new type of string, it abstracts away the details, and we can mentally handle it as a new category.

Maybe I'll go back and refactor that mouthful of `group_by { |x| x }.map { |x, xs| [x, xs.size] }` into an OccurenceCount class, using the same pattern -- this time, masquerading as a Hash.

[^1]: For speed, some Ruby core classes don't perform method-lookup in the traditional way, so your subclass will be left out in the cold. [Steve Klabnik explains it well](http://words.steveklabnik.com/beware-subclassing-ruby-core-classes).

:wq
