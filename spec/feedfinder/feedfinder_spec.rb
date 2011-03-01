require File.dirname(__FILE__) + "/../../lib/feedfinder"
require File.dirname(__FILE__) + "/../spec_helper"

describe "Feedfinder" do
  describe ".feeds" do
    it "Should return an array of feeds" do
      feeds.each do |urls|
        FeedFinder.feeds(urls[0]).should == urls[1].to_a
      end
    end

    it "should yield if a block is given and there are more than one feeds" do
      FeedFinder.feeds(several_feeds[0]) { |feeds| feeds.length.should > 1 }
    end

    it "should not yield if a block is given and there are more than one feeds" do
      yielded = false
      FeedFinder.feeds(single_feed[0]) { |feeds| yielded = true }
      yielded.should be_false
    end

    it "should raise an UrlError if the URL could not be parsed" do
      lambda { FeedFinder.feeds("test") }.should raise_error(FeedFinder::UrlError)
    end

    it "should find feeds when scheme is missing" do
      FeedFinder.feeds(missing_scheme[0]).should == missing_scheme[1].to_a
    end
  end

end
