module FeedFinder
  class Document
    attr_accessor :url

    def initialize(url)
      self.url = url
    end

    def feed?
      return true if feed_content_type?

      not (content =~ /<rss|<feed|<rdf|<RSS|<FEED|<RDF/).nil?
    end

    # Find feeds through <a>s in <body>
    def feed_anchor_links
      feeds = []
      (doc/:body/:a).each do |a|
        link = a['href']
        feeds << uri.merge(link) if local?(link)
      end
      feeds.uniq
    end

    # Find feeds through <link>s in <head>
    def autodiscovery_links
      feeds = []
      (doc/:head/:link).each do |e|
        if e['rel'] == 'alternate' and e['type'] =~ /rss|atom|xml|feed/
          feeds << uri.merge(e['href']).to_s
        end
      end
      feeds.uniq
    end

    private

    CONTENT_TYPES = ['application/rss+xml', 'application/rdf+xml', 'application/atom+xml', 'application/xml', 'text/xml']

    def feed_content_type?
      uri.open do |feed|
        return true if CONTENT_TYPES.include?(feed.content_type.downcase)
      end
      false
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def doc
      @doc ||= Nokogiri(content)
    end

    def content
      @content ||= uri.read
    rescue SocketError => e
      raise UrlError, uri
    end

    def local? feed_url
      feed_uri = URI.parse(feed_url)
      feed_uri.relative? or feed_uri.host.to_s.include?(uri.host.to_s)
    rescue
      false
    end
  end
end
