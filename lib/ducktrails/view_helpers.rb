require 'action_view'
require 'action_view/context'
require 'ducktrails/tags'

module Ducktrails
  module ViewHelpers
    class Breadcrumber < Tag
      def initialize(options = {})
        @template = options[:template]
      end
    end

    def breadcrumbs(&block)
      resources = build_resource(&block)
      ducktrail_render(LinkCollection.new(resources, current_uri).links)
    end

    # TODO: Take this out and just use a view?
    def home_crumb(options = {})
      link_to(duck_config.home_name, duck_config.root_path)
    end

    def build_resource(&block)
      block_given? ? yield : nil
    end

    private

    def duck_config
      @config ||= Ducktrails.config
    end

    def current_uri
      request.fullpath
    end

    def current_action
      Rails.application.routes.recognize_path(current_uri)[:action]
    end

    def ducktrail_render(links)
      @_ducktrail_render ||= Breadcrumber.new(template: self).to_s(links: links)
    end
  end

  ActionView::Base.send :include, Ducktrails::ViewHelpers
end
