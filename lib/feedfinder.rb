$:.unshift File.dirname(__FILE__)

require 'uri'
require 'open-uri'
require 'nokogiri'

require 'feedfinder/url'
require 'feedfinder/doc'

module FeedFinder
  extend self

  # Return array of all feeds at url
  def feeds url
    feeds = FeedFinder::Url.new(url).feeds

    # If there are more than one feed returned, a block can be given to
    # e.g. choose the wanted feed
    if feeds.length > 1 and block_given?
      yield feeds
    else
      feeds
    end
  end

  def feed? url
    FeedFinder::Url.new(url).feed?
  end

  class UrlError < ArgumentError
    def initialize url
      @url = url
    end

    def to_s
      "Could not parse url: #{@url}"
    end
  end
end
