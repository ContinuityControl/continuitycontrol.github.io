---
title:  "Automated Tests for Google Apps Script"
date:   2015-11-04 09:00:00
author: dan_bernier
categories: testing, javascript
excerpt: "What do you do when you're writing Google Spreadsheet extensions in JavaScript, and you want automated tests? Build your own tiny testing framework."
---

I've been using [Google Apps Script](https://en.wikipedia.org/wiki/Google_Apps_Script) lately, to help some of our co-workers get more out of Google Spreadsheets.

I've never used Apps Script before, so I'm learning by exploring, but gradually, I've piled up enough code that, when things break, it's hard to know why. Don't get me wrong - it's structured code (so nice to work in a functional style again!), but bugs can hide anywhere, and I found myself wanting some automated tests.

I could have tried importing Jasmine into Apps Script (have you tried? how'd it go?), but it seemed faster and simpler to write my own tiny testing framework, and write some tests in it. So I did.

# Want to Use It?

If this sounds useful, and you want to grab the code, [here's a gist with the code, and an example of how to use it](https://gist.github.com/danbernier/a15b4073bb5ab13b1864).

If this sounds interesting, and you'd like to see how I wrote it...

# It Starts with Assertions

Really, I didn't write the framework first, and the tests second - they grew together. I started with basic assertions:

{% highlight javascript linenos %}
function allTests(thisFnWrapsAllYourTests) {
  var successes = 0;
  var failures = [];
  
  function runTestAndRecordResult(message, fn) {
    try {
      if (fn()) {
        successes += 1;
      } else {
        failures.push(message);
      }
    }
    catch(x) {
      failures.push(x);
    }
  }
  
  thisFnWrapsAllYourTests({
    areEqual: function(expected, actual) {
      runTestAndRecordResult("Expected " + expected.constructor.name + " " + expected + ", got " + actual.constructor.name + " " + actual + ".", function() {
        return expected === actual;
      });
    },
  });
  
  var totalTests = successes + failures.length;
  alert(successes + " of " + totalTests + " tests passed.\n" + failures.length + " failures.\n" + failures.join("\n"));
}
{% endhighlight %}

That's the bones of most testing frameworks: 

* a place to run your code, and check that you got what you expected
* a framework around that, to track it all, and report back

Here's how it looks in use:

{% highlight javascript linenos %}
// This is called by a menu item, so end-users can run the tests.
function runAllTestsFromTheMenu_() {  

  // Here's where we actually run the tests:
  allTests(function(t) {

    // test that the framework is working
    t.areEqual(1, 1);  
    
    // test the `add` function
    t.areEqual(3, add(1, 2));
    t.areEqual(7, add(0, 7));
    t.areEqual(1, add(10, -9));

    // test the `sum` function
    t.areEqual(10, sum([1,2,3,4]));
    t.areEqual(90, sum([20, 30, 40]));
    t.areEqual(0, sum([0, -50, 20, 30]));
  });
}
{% endhighlight %}

# Organizing Tests with `describe` Blocks

I often hear people say that the `describe` and `its` style of syntax you see in [RSpec](http://rspec.info/), [minitest](https://github.com/seattlerb/minitest), and [jasmine](https://jasmine.github.io/) is surprisingly easy to implement, but I don't usually hear them elaborate on that. Let's take a look.

These syntaxes are really about nesting scopes, and naming them. What we need is a function, and a stack of strings.

So I added a stack of scope messages, and prepended them to all the failure messages. Then, on the test object, I added a `describe` function that pushes its description onto the stack while its function runs:

{% highlight javascript %}
function allTests(thisFnWrapsAllYourTests) {
  ...
  var scopes = [];

  var msgInScope = function(msg) {
    return scopes.concat([msg]).join(": ");
  }

  function runTestAndRecordResult(message, fn) {
    try {
      if (fn()) {
        successes += 1;
      } else {
        failures.push(msgInScope(message));
      }
    }
    catch(x) {
      failures.push(msgInScope(x));
    }
  }

  thisFnWrapsAllYourTests({
    describe: function(blockName, thisFnWrapsOneTest) {
      scopes.push(blockName);
      thisFnWrapsOneTest();
      scopes.pop();
    },
    areEqual: ...
  });
}
{% endhighlight %}

Now I can organize the tests:

{% highlight javascript linenos %}
function runAllTestsFromTheMenu_() {
  allTests(function(t) {
    t.describe("basic tests", function() {
      t.areEqual(1, 1);
    });
    
    t.describe("simple functions", function() {
      t.describe("add", function() {
        t.areEqual(3, add(1, 2));
        t.areEqual(7, add(0, 7));
        t.areEqual(1, add(10, -9));
      });
      
      t.describe("sum", function() {
        t.areEqual(10, sum([1,2,3,4]));
        t.areEqual(90, sum([20, 30, 40]));
        t.areEqual(0, sum([0, -50, 20, 30]));
      });
    });
  });
}
{% endhighlight %}

# That's All!

It's worth noting some of its limitations:

* It doesn't track the successes, it only counts them - but we usually care more about failures.
* It can't tell you which line a failure happened on, only what the expected and actual values were. I get around this by using distinct expected values, but this could be tricky in a larger codebase.
* There's no mocking or stubbing framework built in - but with JavaScript's flexible object model, we can easily inject our own fakes.

# Some Dessert?

There actually is a bit more, but only two minor elaborations to what we already have.

## Close-Enough

You can't reliably test whether two Floats are equal, so it's useful to test whether they're close enough. It's easy to add another method to the testing object.

{% highlight javascript %}
function allTests(thisFnWrapsAllYourTests) {
  ...
  thisFnWrapsAllYourTests({
    ...
    areClose: function(expected, actual, epsilon) {
      if (epsilon === undefined) {
        epsilon = 0.001;
      }
      runTestAndRecordResult("Expected " + expected + " (+/- " + epsilon + "), got " + actual + ".", function() {
        return Math.abs(expected - actual) <= epsilon;
      });
    }
  });
}

function runAllTestsFromTheMenu_() { 
  allTests(function(t) {
    t.describe("averaging", function() {
      t.areClose(4.0/3, average([1,1,2]));
    });
  });
}
{% endhighlight %}

## JavaScript and Array Equality

JavaScript doesn't consider two Arrays with equivalent contents to be equal:

{% highlight javascript %}
[1,2,3] === [1,2,3] // false
{% endhighlight %}

Since `t.areEqual` uses `===` to test equality, we can't use that for comparing Arrays.

Again, we can add a method to the test function to iteratively and recursively compare the Array contents with `===`:

{% highlight javascript %}
function allTests(thisFnWrapsAllYourTests) {
  ...
  var doTheseListsMatch = function(expected, actual) {
    if (expected.length != actual.length) {
      return false;
    }
    
    for (var i = 0; i < expected.length; i++) {
      if (expected[i].constructor === Array && actual[i].constructor === Array) {
        if (!doTheseListsMatch(expected[i], actual[i])) {
          return false;
        }
      }
      else if (expected[i] !== actual[i]) {
        return false;
      }
    }
    return true;
  }

  thisFnWrapsAllYourTests({
    ...
    listMatch: function(expected, actual) {
      runTestAndRecordResult("Expected " + expected + ", got " + actual + ".", function() {
        return doTheseListsMatch(expected, actual);
      });
    }
  });
}

function runAllTestsFromTheMenu_() { 
  allTests(function(t) {
    t.describe("map", function() {
      var input = [1,2,3];
      var expected = [10,20,30];
      t.listMatch(expected, map(input, function(x) { return x * 10; }));
    }); 
  });
}
{% endhighlight %}
