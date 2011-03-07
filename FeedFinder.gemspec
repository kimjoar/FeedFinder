$:.unshift 'lib'
require 'feedfinder/version'

Gem::Specification.new do |s|
  s.name        = %q{FeedFinder}
  s.version     = FeedFinder::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.platform    = Gem::Platform::RUBY
  s.homepage    = %q{http://github.com/olav/FeedFinder}
  s.authors     = ["Olav Bjorkoy", "Kim Joar Bekkelund"]
  s.email       = %q{olav@bjorkoy.com}
  s.summary     = %q{Discovers feeds for a given URL.}
  s.description = %q{Discovers feeds for a given URL.}

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "nokogiri", "~> 1.4.4"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]
end
