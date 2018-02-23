require 'concerns/configurable'

DEFAULTS = {
  key: :name,
  policy: true
}.freeze

module Ducktrails
  class LinkCollection
    include Configurable

    attr_accessor :resources, :current_uri

    def initialize(resources, current_uri)
      @resources ||= default_resources(resources)
      @current_uri ||= current_uri
    end

    def links
      split_uri.inject([]) do |links, uri_resource|
        links << Resource.new(resources, uri_resource, current_uri)
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
        @resource = resource[1]
        resources.merge(
          resource[0] => DEFAULTS.merge(sanitized_resource)
        )
      end
    end

    # Used to filter and sanitize decorated resources
    def sanitized_resource
      return @resource if @resource.is_a?(String)
      return unobjectified_resource if resource_decorated?
      @resource
    end

    def unobjectified_resource
      @resource[:resource] = @resource[:resource].object
      @resource
    end

    def resource_decorated?
      @resource[:resource].respond_to?(:decorated?) &&
        @resource[:resource].decorated?
    rescue NoMethodError
      @resource
    end
  end
end
