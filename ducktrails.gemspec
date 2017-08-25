$:.push File.expand_path("../lib", __FILE__)
require "ducktrails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ducktrails"
  s.version     = Ducktrails::VERSION
  s.authors     = ["Kevin Brown"]
  s.email       = ["chevinbrown@gmail.com"]
  s.homepage    = "http://github.com/proctoru/ducktrails"
  s.summary     = "Ducktrails: Breadcrumbs that are duckin' awesome."
  s.description = "RESTful breadcrumbs"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = '>= 2.0.0'

  s.require_paths = ['lib']

  s.add_dependency "rails", ">= 4.1"

  s.add_development_dependency 'pg'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'minitest-rails-capybara'
end
