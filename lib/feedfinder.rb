require 'uri'
require 'open-uri'
require 'rubygems'
require 'nokogiri'

module FeedFinder
  class UrlError < ArgumentError
    def initialize(url)
      @url = url
    end

    def to_s
      "Could not parse url: #{@url}"
    end
  end

  # Return array of all feeds at url
  def self.feeds(url)
    uri = url_to_uri(url)
    return [url] if feed?(uri)
    feeds = find_feed_links(uri)
    return nil if feeds.empty?

    if feeds.length > 1 and block_given?
      yield feeds
    else
      feeds
    end
  end

  private

  def self.feed?(uri)
    feed_url?(uri.to_s) and points_to_feed?(uri)
  end

  # Check if an url looks like a feed url
  def self.feed_url?(url)
    not (url =~ /\.xml|atom|rss|rdf|feed|feedproxy|feedburner/).nil?
  end

  # Check if an url really points to a proper feed
  def self.points_to_feed?(uri)
    data = download_from_uri(uri)
    not (data =~ /<rss|<feed|<rdf|<RSS|<FEED|<RDF/).nil?
  end

  # Get possible feed links from uri
  def self.find_feed_links(uri)
    doc = Nokogiri(download_from_uri(uri))
    feeds = find_autodiscovery_links(uri, doc)
    feeds = find_feed_anchor_links(uri, doc) if feeds.empty?
    feeds.find_all { |f| points_to_feed?(f) }
  end

  # Find feeds through <link>s in <head>
  def self.find_autodiscovery_links(uri, doc)
    feeds = []
    (doc/:head/:link).each do |e|
      if e['rel'] == 'alternate' and e['type'] =~ /rss|atom|xml|feed/
        feeds << uri.merge(e['href']).to_s
      end
    end
    feeds.uniq
  end

  # Find feeds through <a>s in <body>
  def self.find_feed_anchor_links(uri, doc)
    feeds = []
    (doc/:body/:a).each do |a|
      if feed_url?(a['href'])
        begin
          link = URI.parse(a['href'])
          if link.relative? or link.host.to_s.include?(uri.host.to_s)
            feeds << uri.merge(a['href']).to_s
          end
        rescue
        end
      end
    end
    feeds.uniq
  end

  # Download html via url object
  def self.download_from_uri(uri)
    open(uri, "User-Agent" => "Ruby/#{RUBY_VERSION}").read
  rescue Exception => e
    raise UrlError, uri
  end

  # Convert any url to an uri object
  def self.url_to_uri(url)
    url = ('http://' + url).gsub('///','//') unless url =~ /http:\/\//
    URI.parse(url)
  rescue Exception
    raise UrlError, url
  end
end
