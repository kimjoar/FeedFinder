$:.unshift File.expand_path("../lib", __FILE__)
require "feedfinder/version"

task :build do
  system "gem build FeedFinder.gemspec"
end

task :release => :build do
  system "gem push FeedFinder-#{FeedFinder::VERSION}"
end
