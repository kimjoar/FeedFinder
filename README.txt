This simple script takes a URL and returns all feeds found at that address. 

* Both RSS and Atom feeds are found.
* Each feed link is verified to point to an actual feed.

Usage:

FeedFinder.feeds('http://www.example.com')
=> Returns an array of all found feeds, or nil if no feeds are found.

Dependencies:

* Hpricot
