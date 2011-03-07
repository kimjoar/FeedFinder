module FeedFinder
  class Url
    attr_accessor :url

    def initialize(url)
      self.url = url
    end

    def feeds
      if feed?
        [url]
      else
        feed_links
      end
    end

    def feed?
      feed_url? and document.feed?
    end

    private

    def document
      @doc ||= FeedFinder::Document.new(url)
    end

    def feed_url?
      not (url =~ /\.xml|atom|rss|rdf|feed|feedproxy|feedburner/).nil?
    end

    def feed_links
      feeds = document.autodiscovery_links
      feeds = document.feed_anchor_links if feeds.empty?
      feeds.find_all { |f| FeedFinder::Url.new(f).feed? }
    end

    def url= url
      @url = url
      @url = ('http://' + url).gsub('///','//') unless url =~ /http:\/\//
    end
  end
end
