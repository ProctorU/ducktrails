require 'active_support/configurable'

module Ducktrails
  def self.configure(&block)
    yield @config ||= Ducktrails::Configuration.new
  end

  def self.config
    @config ||= self.config
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor :theme { 'ducktrails' }
    config_accessor :home_name { 'Home' }
    config_accessor :root_path { '/' }
    config_accessor :collection_prefix { 'All' }
    config_accessor :default_key { :id }
  end
end
