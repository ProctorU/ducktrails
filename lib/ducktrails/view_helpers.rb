require 'action_view'
require 'action_view/context'
require 'ducktrails/tags'

module Ducktrails
  module ViewHelpers
    class Breadcrumber < Tag
      include ::ActionView::Context

      def initialize(template, options = {})
        @template = template

        @output_buffer = ActionView::OutputBuffer.new
      end

      def render(&block)
        @output_buffer
      end
    end

    def breadcrumbs(options = {})
      ducktrail_render
    end

    def home_crumb(options = {})
      link_to(Ducktrails.config.home_name, '/')
    end

    private

    def split_uri
      current_uri.split('/').reject(&:empty?)
    end

    def current_uri
      request.env['PATH_INFO']
    end

    def ducktrail_render
      @_ducktrail_render ||= Breadcrumber.new(self, split_uri).to_s
    end
  end

  ActionView::Base.send :include, Ducktrails::ViewHelpers
end
