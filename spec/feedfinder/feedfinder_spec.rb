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

    it "should yield if a block is given and there are more than one feeds" do
      FeedFinder.feeds(@feeds.last[0]) { |feeds| feeds.length.should > 1 }
    end

    it "should not yield if a block is given and there are more than one feeds" do
      yielded = false
      FeedFinder.feeds(@feeds.first[0]) { |feeds| yielded = true }
      yielded.should be_false
    end

    it "should raise an UrlError if the URL could not be parsed" do
      lambda { FeedFinder.feeds("test") }.should raise_error(FeedFinder::UrlError)
    end
  end

end
