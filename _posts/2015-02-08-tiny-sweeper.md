---
title: Tidy Your Attributes with TinySweeper
date:   2015-02-08 14:20:00
author: dan_bernier
excerpt: It can be easy to clean up your model attributes.
---

I hate seeing this:

{% highlight ruby linenos %}
2.2.0 :001 > Sundae.group(:topping).count
 => {nil=>120, ""=>14, "hot fudge "=>2, "hot fudge"=>73, "butterscotch"=>33, "bourbon"=>4}
{% endhighlight %}

`blank?` makes it easy to gloss over the two kinds of non-values, but it's still annoying. And it won't help with those two kinds of hot fudge.

It's easy for data to get this way. The most natural place to put this clean-up logic is in the writer attributes or `before_validation` hooks, but it's tedious to remember them all.

[Rich Hickey's 2012 RailsConf keynote](https://www.youtube.com/watch?v=rI8tNMsozo0) was titled "Simplicity Matters," but at StrangeLoop, he called it [Simple Made Easy](http://www.infoq.com/presentations/Simple-Made-Easy). I like that title better: simplicity is more valuable to programmers, so let's make simple solutions easy to implement.

What we need is a simple way to make cleaning attributes easy.

(How's that for a setup?)

Enter [TinySweeper](https://rubygems.org/gems/tiny_sweeper): a gem that lets you define cleaning rules for any writer method on a ruby class.

Here's how you use it - here's the core idea of it:

{% highlight ruby linenos %}
class Sundae < ActiveRecord::Base
  include TinySweeper
  sweep(:topping) { |t|
    if t.blank?
      nil
    else
      t.strip
    end
  }
end

dessert = Sundae.new
dessert.topping = "hot fudge "
dessert.topping #=> "hot fudge"
# and then...
dessert.topping = ""
dessert.topping #=> nil
{% endhighlight %}

You include the TinySweeper module, and define which fields should be cleaned, and how. The block sits in front of the writer method, intercepts values on their way in, sweeps them clean, and passes them on. That means you don't have to save the Sundae for the topping to be cleaned.

There will be more to it, to make it easier to use, but it will all be built around that core idea. It's only at version 0.0.4.

## Prepending Modules

The first draft of TinySweeper was a bit inelegant: it would alias your writer method to something like "original topping="[^space-methods], and redefine it to clean up the value, and pass it to the original version. This method-juggling is effective, but it's clumsy. And those "original foo=" methods show up in `#methods`.

[^space-methods]: That's right, methods with spaces in the name are legal - though you can't call it with the dot syntax. Try making some with `define_method`.

Ruby 2.0 introduced us to the idea of prepending a module, which can help us out here. When you include a module, its methods are placed into the call-chain after the class, but before its superclass. Code like this:

{% highlight ruby linenos %}
module Extras
end

class Basics
  include Extras
end
{% endhighlight %}

...sets up like this:

![](/images/module-include.png)

But if you prepend the module, its methods are placed into the call-chain *before* the current class:

![](/images/module-prepend.png)

So, if you prepend a module into your class, its methods can call `super`, and it'll call the corresponding method on your class. This is just what TinySweeper needs - and in [this commit](https://github.com/ContinuityControl/tiny_sweeper/commit/1300bdcb15ed5982a132faec152de2f3d3b09d78), you can see the before-and-after effect on the code.

Lots of articles about prepending modules use memoization as the illustrating example, and it's a good use case. But any time you need to do something before a method is called, or after, prepending a module might be a good idea. It's a lot like [Rails' request filters](http://guides.rubyonrails.org/action_controller_overview.html#filters). If you'd like to read more about it, [Micah Woods](http://hashrocket.com/blog/posts/module-prepend-a-super-story) has a good write-up.

## Rolling Out TinySweeper

We're just starting to use TinySweeper at Continuity, so it's early, but I bet we'll be updating it to make it easy to use in the near future. If you have ideas, [pull requests are welcome!](https://github.com/ContinuityControl/tiny_sweeper)

