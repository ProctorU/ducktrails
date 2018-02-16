require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "ducktrails"

module Dummy
  class Application < Rails::Application
    # FactoryGirl.definition_file_paths << Pathname.new("../factories")
    # FactoryGirl.definition_file_paths.uniq!
    # FactoryGirl.find_definitions
    config.eager_load = false
  end
end
