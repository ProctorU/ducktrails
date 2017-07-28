require 'action_view'
require 'action_view/context'
require 'ducktrails/tags'

module Ducktrails
  module ViewHelpers
    class Breadcrumber < Tag
      def initialize(options = {})
        @template = options[:template]
        @output_buffer = ActionView::OutputBuffer.new
      end

      def render(&block)
        @output_buffer
      end
    end

    def breadcrumbs(&block)
      resources = block_given? ? yield : nil

      ducktrail_render(LinkCollection.new(resources, current_uri, current_request).links)
    end

    def home_crumb(options = {})
      link_to(Ducktrails.config.home_name, Ducktrails.config.root_path)
    end

    private

    def current_uri
      request.fullpath
    end

    def current_request
      request
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
