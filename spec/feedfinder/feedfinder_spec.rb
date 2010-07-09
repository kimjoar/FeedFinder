require File.dirname(__FILE__) + "/../../lib/feedfinder"
require File.dirname(__FILE__) + "/../spec_helper"

describe "Feedfinder" do
  
  before do
    @feeds = [
      ['http://bjorkoy.com', 'http://feeds.feedburner.com/bjorkoy'],
      ['http://w3.org', 'http://w3.org/News/atom.xml'],
      ['http://newyorktimes.com', 'http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml'],
      ['http://googleblog.blogspot.com', 
        ['http://googleblog.blogspot.com/feeds/posts/default',
         'http://googleblog.blogspot.com/feeds/posts/default?alt=rss']]
    ]
  end
  
  describe ".feeds" do
    it "Should return an array of feeds" do
      @feeds.each do |urls|
        FeedFinder.feeds(urls[0]).should == urls[1].to_a
      end
    end
  end
  
end