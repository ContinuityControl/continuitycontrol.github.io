---
layout: post
title:  "CSV Tricks"
date:   2015-01-16 23:00:00
author: dan_bernier
---

Ruby has some decent CSV capabilities in its [CSV](http://www.ruby-doc.org/stdlib-2.2.0/libdoc/csv/rdoc/CSV.html) class. I came across two tricks recently that aren't clearly pointed out in the docs, and don't really fit there, so I'll explain them here.

# Lazily Streaming Large CSV Files

The CSV class provides a handy way to quickly read a whole CSV file into memory as an array-of-arrays. Straight from the docs:

{% highlight ruby %}
arr_of_arrs = CSV.read("path/to/file.csv")
{% endhighlight %}

This is great if your CSV file is small enough to fit into available RAM. If it's too big, you can use `CSV.foreach`. Again from the docs:

{% highlight ruby %}
CSV.foreach("path/to/file.csv") do |row|
  # use row here...
end
{% endhighlight %}

But what if you want to pass that CSV around, or process the rows as a stream? If you call `foreach` _without_ a block, it'll return an Enumerator! This is handy:

{% highlight ruby %}
irb:001 > csv_stream = CSV.foreach("honkin.big.csv")
 => #<Enumerator: CSV:foreach("honkin.big.csv", {})>
irb:002 > pp csv_stream.take(3)
[["Habibi", "Craig Thompson"],
 ["What If?: Serious Scientific Answers to Absurd Hypothetical Questions",
  "Randall Munroe"],
 ["Hacker, Hoaxer, Whistleblower, Spy: The Many Faces of Anonymous",
  "Gabriella Coleman"]]
{% endhighlight %}

This flexibility means it's easy to treat the CSV rows as a lazy stream, and run through it, collecting data, without consuming all the RAM and crashing your pairing machine. (Of course, if you actualize the whole collection - say, by mapping it - you'll still consume lots of memory. Be careful out there.)

Lazy processing is a whole subject by itself, but if you're curious about it, poke around some functional languages. Clojure and Elixir both have good support for laziness.

# Adding Fields to CSV Rows

Most of the CSV class methods for opening a file accept a hash of options. One option is `:headers`; if you pass `headers: true`, then, instead of an array of arrays, you'll get an array of [CSV::Row](http://www.ruby-doc.org/stdlib-2.2.0/libdoc/csv/rdoc/CSV/Row.html) objects.

{% highlight ruby %}
irb:001 > CSV.foreach('christmas-gifts.csv').first
 => [["title", "author"]]
irb:002 > CSV.foreach('christmas-gifts.csv', headers: true).first
 => #<CSV::Row "title":"Habibi" "author":"Craig Thompson">
{% endhighlight %}

So far, so good.

What I didn't realize - until I tried it - was how easy it is to add another field to a CSV row.

Think about it for a minute: will the fields stay in the right order? Order matters in a CSV file! If you want to write the CSV out to another file, do you have to manage the order of the columns?

It turns out it's easier than I was making it - Ruby takes care of it.

{% highlight ruby %}
irb:001 > CSV.foreach('products.csv', headers: true).first
 => #<CSV::Row "a":"2" "b":"3">
irb:002 > _.headers
 => ["a", "b"]
irb:007 > CSV.foreach('products.csv', headers: true) do |row|
irb:008 >     row['c'] = row['a'].to_i * row['b'].to_i
irb:009?>   p row
irb:000?>   end
#<CSV::Row "a":"2" "b":"3" "c":6>
#<CSV::Row "a":"4" "b":"5" "c":20>
#<CSV::Row "a":"6" "b":"7" "c":42>
{% endhighlight %}

This means it's really easy to process a CSV file, and calculate new fields from other fields.

{% highlight ruby %}
CSV.foreach('tasks.csv', headers: true) do |row|
  row['duration'] = row['finished_at'].to_i - row['created_at'].to_i
end
{% endhighlight %}

# What Other Treasures Lie Hidden?

I found these two tricks while processing a bit of data, hacking around. The CSV classes aren't terribly well-documented; I might experiment some more, and [make some pull requests](http://documenting-ruby.org/). [#filter](http://www.ruby-doc.org/stdlib-2.2.0/libdoc/csv/rdoc/CSV.html#method-c-filter) looks interesting...

:wq
