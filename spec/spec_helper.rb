require 'fakeweb'

def single_feed
  feeds.first
end

def several_feeds
  feeds.last
end

def feeds
  [
    ['http://bjorkoy.com', ['http://feeds.feedburner.com/bjorkoy']],
    ['http://w3.org', ['http://w3.org/News/atom.xml']],
    ['http://newyorktimes.com', ['http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml']],
    ['http://googleblog.blogspot.com',
      ['http://googleblog.blogspot.com/feeds/posts/default',
       'http://googleblog.blogspot.com/feeds/posts/default?alt=rss']
    ]
  ]
end

class String
  def slugify
    str = self.dup
    str.gsub!(/[^a-zA-Z0-9 ]/,"")
    str.gsub!(/[ ]+/," ")
    str.gsub!(/ /,"-")
    str.downcase!
    str
  end
end

def cache_dir
  File.join(File.dirname(__FILE__), 'cache')
end

def cache!
  Dir.mkdir(cache_dir) unless File.directory?(cache_dir)
  feeds.flatten.each { |f| cache_url! f }
end

def cache_url!(url)
  File.open(File.join(cache_dir, url.slugify), 'w') do |f|
    f.write open(url).read
  end
end

def cached?
  Dir.entries(cache_dir).length > 2 rescue false
end

def fake_it!
  cache! unless cached?
  feeds.flatten.each do |f|
    FakeWeb.register_uri :get, f, :body => File.read(File.join(cache_dir, f.slugify))
  end
end

fake_it!
