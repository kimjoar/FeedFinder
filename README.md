FeedFinder
==========

This simple script takes a URL and returns all feeds found at that address.

* Both RSS and Atom feeds are found.
* Each feed link is verified to point to an actual feed.

Usage
-----

    FeedFinder.feeds('http://www.example.com')
    => Returns an array of all found feeds (and an empty one if none are found).

    FeedFinder.feed?('http://www.example.com')
    => Whether or not the URL is a feed

Dependencies
------------

* Nokogiri
