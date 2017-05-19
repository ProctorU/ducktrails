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
    @config
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :home_name
    config_accessor :collection_prefix

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end

    # define param_name writer (copied from AS::Configurable)
    writer, line = 'def param_name=(value); config.param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.home_name = 'Home'
    config.collection_prefix = 'All'
  end
end
