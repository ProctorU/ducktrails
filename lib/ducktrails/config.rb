require 'active_support/configurable'

module Ducktrails
  # Configures global settings for Ducktrails
  #   Ducktrails.configure do |config|
  #     config.default_per_page = 10
  #   end
  def self.configure(&block)
    yield @config ||= Ducktrails::Configuration.new
  end

  # Global settings for Ducktrails
  def self.config
    @config ||= self.config
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor :theme,
      :home_name,
      :root_path,
      :collection_prefix,
      :default_key
  end

  configure do |config|
    config.theme = 'ducktrails'
    config.home_name = 'Home'
    config.root_path = '/'
    config.collection_prefix = 'All'
    config.default_key = :id
  end
end
