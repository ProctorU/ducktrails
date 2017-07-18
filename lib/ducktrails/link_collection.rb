require 'concerns/configurable'

DEFAULTS = {
  key: :name,
  policy: true
}

module Ducktrails
  class LinkCollection < Array
    include Configurable

    attr_accessor :resources, :current_uri, :request

    def initialize(resources, current_uri, request)
      @resources ||= set_default_resources(resources)
      @current_uri ||= current_uri
      @request ||= request
    end

    def links
      build_links
    end

    private

    # All the logic to build the links
    # Should render an index & show if action is show
    # Should render an index & new/edit if action is new/edit
    # Should render an index as _current_page if action is index
    # If resources are empty, generate breadcrumbs from the uri?
    def build_links
      return generate_uri_breadcrumbs if Ducktrails.config.fallback_to_uri || @resources.nil?
      raise 'Please provide block configuration for breadcrumbs.'
    end

    def generate_uri_breadcrumbs
      split_uri.inject([]) do |links, uri_resource|
        links << build_uri_link(uri_resource)
      end.compact
    end

    def build_link(text, uri)
      {
        text: text,
        uri: uri
      }
    end

    def build_uri_link(uri_segment)
      index = split_uri.index(uri_segment)
      if resources[uri_segment.to_sym].present?
        return unless resources[uri_segment.to_sym][:policy]
        # Build resource link
        # example /institutions/:institution_id/iterations/:id
        build_link(text_link(resources[uri_segment.to_sym], index.odd?), split_uri[0..index].join('/').prepend('/'))
      elsif index.odd? && resources[split_uri[index - 1].to_sym].present?
        return unless resources[split_uri[index - 1].to_sym][:policy]
        build_link(text_link(resources[split_uri[index - 1].to_sym], index.odd?), split_uri[0..index].join('/').prepend('/'))
      else
        # build links based off of uri
        build_link(text_link(uri_segment.underscore.humanize, index.odd?), split_uri[0..index].join('/').prepend('/'))
      end
    end

    # TODO factor out the resource & key to use config if key is nil
    def text_link(resource, show_action = nil)
      if resource.is_a?(String)
        return resource if show_action
        return resource.prepend(collection_prefix)
      end

      if resource[:resource].nil?
        return request_pattern[:controller].split('/').last.underscore.humanize.pluralize.prepend(collection_prefix)
      end

      if show_action
        return resource[:resource].send(resource[:key])
      else
        return resourcer(resource)
      end
    end

    def resourcer(resource)
      resource = resource[:resource].object if resource[:resource].respond_to?(:object)
      resource.class.name.split('::').first.underscore.humanize.pluralize.prepend(collection_prefix)
    end

    def request_pattern
      @request_pattern ||= Rails.application.routes.recognize_path(current_uri)
    end

    def split_uri
      @split_uri ||= current_uri.split('/').reject(&:empty?)
    end

    def action
      @action ||= request_pattern[:action]
    end

    def set_default_resources(yield_resources = nil)
      return if yield_resources.nil?
      yield_resources.inject({}) do |resources, resource|
        resources.merge(
          {
            resource[0] => DEFAULTS.merge(resource[1])
          }
        )
      end
    end
  end
end
