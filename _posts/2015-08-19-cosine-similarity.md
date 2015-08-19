---
title: Fuzzy Matching with Cosine Similarity
author: dan_bernier
date:   2015-08-19
excerpt: A simple algorithm to tell when things are just a LITTLE different.
---

How many times have we tried to match up items from two systems, and they don't match perfectly, so we can't match them directly?

![](/images/similar.jpg)
[via](http://imgur.com/gallery/02gcbn2)

**_WARNING_**: Fuzzy-matching is probabilistic, and will probably eat your face off if you trust it too much. That said, I recently found the science on an effective, simple solution: [cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity).

I got the deets from Grant Ingersoll's book [Taming Text](http://www.amazon.com/Taming-Text-Find-Organize-Manipulate/dp/193398838X/), and from [Richard Clayton's posts](http://www.gettingcirrius.com/2010/12/calculating-similarity-part-1-cosine.html). Joel also found [this post](https://www.bionicspirit.com/blog/2012/01/16/cosine-similarity-euclidean-distance.html) that goes into more detail, and more math and code.

Cosine matching is a way to determine how similar two things are to each other. It's a linear algebra trick:

* two things are similar if their properties are similar
* if you can express each of these properties as a number, you can think of those numbers as coordinate values in a grid - i.e., as a vector
* it's straight-forward to calculate the angle between two vectors (this involves their "dot product", and their length, or "magnitude", which is just their Euclidean distance)
* if the angle is small, they're similar; if it's large, they're dissimilar

This is a useful idea! (Linear algebra is the math I always wish I'd paid more attention to, and stuff like this is why.)

I implemented it. The code is below, but first, here's how it ranks some strings (scores truncated to 4 decimal places for readability):

| One String                    | Another String                  | cosine similarity |
| ----------                    | --------------                  | ----------------- |
| string                        | gnirts                          | 1.0               |
| Radiohead                     | Carly Rae Jepsen                | 0.4717            |
| The Beatles                   | Taylor Swift                    | 0.4905            |
| identical strings             | identical strings               | 1.0               |
| First National Bank of Alaska | Fst Nat'l Bank of Alaska        | 0.9534            |
| First National Bank of Alaska | First National Bank of Kentucky | 0.8964            |

Notice that "string" and "gnirts" ("string" backwards) are considered identical. Remember: it'll eat your face off if you trust it too much. That said, "The Beatles" and "Taylor Swift" are reassuringly dissimilar.

Here's the ruby:

{% highlight ruby linenos %}
def cosine(a, b)
  ac = a.downcase.split('')
  bc = b.downcase.split('')

  set = ac | bc

  afreq = count(ac)
  bfreq = count(bc)

  av = set.map { |x| afreq.fetch(x, 0) }
  bv = set.map { |x| bfreq.fetch(x, 0) }

  dot(av, bv) / (mag(av) * mag(bv).to_f)
end

def dot(a, b)
  # Now that I've written it in Ruby, I think
  # I might have a chance of remembering it.
  a.zip(b).map { |m, n| m * n }.reduce(:+)
end

def mag(v)
  Math.sqrt(v.map { |x| x ** 2 }.reduce(:+))
end

def count(items)
  items.group_by { |x| x }.map { |x, xs| [x, xs.size] }.to_h
end
{% endhighlight %}

There's not much to it.

## Bi-grams

It's annoying that "string" and "gnirts" count as identical. But it's a good reminder that you have to be careful _how_ you express an item's properties as numbers. Here, the only properties are how many times each character appears.

But before you shout "[Levenshtein edit distance](https://en.wikipedia.org/wiki/Levenshtein_distance)," we can improve the matches by counting not characters, but [character bi-grams](https://en.wikipedia.org/wiki/Bigram). Don't count `%w(s t r i n g)`, count `%w(st tr ri in ng)`. Since "string" and "gnirts" have no bi-grams in common, their cosine similarity drops to 0. That's pretty good.

Here are the scores, side-by-side:

| One String                    | Another String                  | cosine, letters | cosine, bi-grams |
| ----------                    | --------------                  | -----------------        | ------------------------- |
| string                        | gnirts                          | 1.0                      | 0.0                       |
| Radiohead                     | Carly Rae Jepsen                | 0.4717                   | 0.1400                    |
| The Beatles                   | Taylor Swift                    | 0.4905                   | 0.0801                    |
| identical strings             | identical strings               | 1.0                      | 1.0                       |
| First National Bank of Alaska | Fst Nat'l Bank of Alaska        | 0.9534                   | 0.8232                    |
| First National Bank of Alaska | First National Bank of Kentucky | 0.8964                   | 0.7647                    |

Notice that "The Beatles" and "Taylor Swift" are now _even more reassuringly dissimilar_.

Here's the extra code that implements the bi-gram comparison:

{% highlight ruby linenos %}
def ngrams(s)
  # Add spaces, front & back, so we count which letters start & end words.
  letters = [' '] + s.downcase.split('') + [' ']
  letters.each_cons(2).to_a
end

def cosine_ngram(a, b)
  a_ngrams = ngrams(a)
  b_ngrams = ngrams(b)

  set = a_ngrams | b_ngrams

  afreq = count(a_ngrams)
  bfreq = count(b_ngrams)

  av = set.map { |x| afreq.fetch(x, 0) }
  bv = set.map { |x| bfreq.fetch(x, 0) }

  dot(av, bv) / (mag(av) * mag(bv).to_f)
end
{% endhighlight %}

## It's Not Just For Strings!

The reason I'm more excited about cosine similarity than something like Levenshtein edit distance is because it's not specific to comparing bits of text. Remember: if you can express the properties you care about as a number, you can use cosine similarity to calculate the similarity between two items.

At Continuity, we clearly think a lot about Banks and Credit Unions. Suppose we're trying to tell whether [a record from the FDIC's BankFind service](/fdic-gem) matches a record in our database. We can cosine-similarity compare the names, of course, but both the FDIC and Continuity store other data: the FDIC Certificate number, the asset size, the number of branches...each of these properties can be expressed as a dimension of the vector, which means they can also help us decide whether two records represent the same Bank or Credit Union.

This generality makes cosine similarity so useful! We're already reconsidering some engineering problems in light of cosine similarity, and it's helping us through situations where we can't expect exact matches. A simple, general, useful idea is a good thing to find.

:wq
