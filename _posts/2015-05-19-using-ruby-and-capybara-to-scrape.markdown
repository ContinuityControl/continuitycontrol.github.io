---
layout: post
title: "Using Ruby and Capybara to Scrape"
date: 2015-05-19T20:27:08+00:00
author: zach_morek
modified:
categories:
excerpt: Use every day rubyist tools to scrape websites.
tags: []
image:
  feature:
---

## TL; DR

* Create a wrapper class
* `include Capybara::DSL`
* `visit 'http://any.website.you.want.com'`

## The Copy-Pasteable Bits

### The Setup

```ruby
require 'csv'
require 'capybara'
require 'capybara/poltergeist'

class WebScraper
  include Capybara::DSL
  Capybara.default_driver = :poltergeist
  Capybara.register_driver :poltergeist do |app|
    options = { js_errors: false }
    Capybara::Poltergeist::Driver.new(app, options)
  end

  def scrape
    yield page
  end

  def self.scrape(&block)
    new.scrape(&block)
  end
end
```

### The Crawling

```ruby
WebScraper.scrape do |page|
  page.visit 'http://google.com/search?q=foo'

  10.times do |i|
    begin
      File.write("search_#{i}.html", page.html)
      page.within '#foot' do
        page.has_content? 'Next'
        page.find_link('Next').trigger('click')
      end
      sleep 5 # wait so that we don't hit their server too hard
    rescue Capybara::ElementNotFound
      # require 'byebug'; byebug # use this to start investigating why the page link is broken
      puts 'could not find link'
    end
  end
end
```

### The Parsing

```ruby
csv_rows = []
Dir.glob('search*.html').each do |file_path|
  page = File.open(file_path)
  rows = Nokogiri::HTML(page).css('div#search div#ires li.g') # grab each result
  rows.each do |row|
    link_text = row.css('h3.r').text
    green_url = row.css('div.kv cite').text
    description = row.css('span.st').text

    csv_rows << [link_text, green_url, description]
  end
end

CSV.open('searches.csv', 'wb') do |csv|
  csv_rows.each do |csv_row|
    csv << csv_row
  end
end
```

## Random Thoughts That May Be Helpful

We decided to use Capybara since it readily uses javascript in its headless browser, but Mechanize doesn't. Also since we already are using Capybara for our test suite, it's a much more familiar tool to use when programmatically navigating web pages. The code above is a bit of a simplified example, but structurally can be extended to handle arbitrary page navigation and data grabbing.

* Doing the page grabbing and data scraping separate allows us to gather data and save it in case our scraper runs into problems
* You will likely have to cleanup your csv after you finish. Pages will have edge cases you didn't plan for when scraping. If you've saved your files while scraping you'll save yourself the trouble of re-running the entire web crawling part.
* Scope your css or xpaths as specific as you can to make sure you get only the right elements

## Code Tips

* `sleep x` timers are good to keep from getting rate limited or blocked, it's also being nice to their servers :-)
* Extra `puts x` statements can be helpful in keeping track of what page you're on in a long and slow scrape.
* Use `byebug` and other debugging tools to figure out why links aren't working or pages are parsing wrong
* Put all your scraping stuff into its own dir so that you don't mix files up: `FileUtils.mkdir_p "page_dumps/#{Date.today.iso8601}"`
* Useful trick for file naming: `1.to_s.rjust(3, '0') # => 001`

## Other useful tools for scraping

* [The Simple Way to Scrape an HTML Table: Google Docs - eagereyes](https://eagereyes.org/data/scrape-tables-using-google-docs)

:wq
