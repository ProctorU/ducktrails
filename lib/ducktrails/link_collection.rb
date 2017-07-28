require 'concerns/configurable'

DEFAULTS = {
  key: :name,
  policy: true
}.freeze

module Ducktrails
  class LinkCollection < Array
    include Configurable

    attr_accessor :resources, :current_uri, :request

    def initialize(resources, current_uri, request)
      @resources ||= default_resources(resources)
      @current_uri ||= current_uri
      @request ||= request
    end

    def links
      split_uri.inject([]) do |links, uri_resource|
        links << Resource.new(resources, uri_resource, split_uri, current_uri)
          .link
      end.compact
    end

    private

    def split_uri
      @split_uri ||= current_uri.split('/').reject(&:empty?)
    end

    def default_resources(yield_resources = nil)
      return {} if yield_resources.nil?
      yield_resources.inject({}) do |resources, resource|
        resource[1].assert_valid_keys(Ducktrails::VALID_RESOURCES)
        resources.merge(resource[0] => DEFAULTS.merge(resource[1]))
      end
    end
  end
end
