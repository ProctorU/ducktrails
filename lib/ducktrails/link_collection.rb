module Ducktrails
  class LinkCollection < Array
    attr_accessor :resources, :current_uri, :request

    def initialize(resources, current_uri, request)
      @resources ||= resources
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
      if resources.blank?
        return generate_uri_breadcrumbs if Ducktrails.config.fallback_to_uri
        raise 'Please provide block configuration for breadcrumbs.'
      else
        generate_resource_breadcrumbs
      end
    end

    def generate_uri_breadcrumbs
      split_uri.inject([]) do |links, uri_resource|
        links << build_uri_link(uri_resource)
      end
    end

    def generate_resource_breadcrumbs
      split_uri.inject([]) do |links, uri_resource|
        if resources.include?(uri_resource.to_sym)
          action = request_pattern[:action]
          # Add both the index link and the show link
          if action.eql?('show')
            links << create_collection_link(resources[uri_resource.to_sym])
            links << create_show_link(resources[uri_resource.to_sym])
          else
            links << create_collection_link
          end
        else
          links
        end
      end.flatten.compact
    end

    def build_link(text, uri)
      {
        text: text,
        uri: uri
      }
    end

    def build_uri_link(uri_segment)
      index = split_uri.index(uri_segment)
      build_link(text_link(uri_segment.underscore.humanize, index.odd?), split_uri[0..index].join('/').prepend('/'))
    end

    def create_collection_link(resource)
      build_link(text_link(resource), uri: split_uri.take(1).join('/').prepend('/'))
    end

    def create_show_link(resource)
      build_link(requested_resource_key, current_uri)
    end

    # TODO factor out the resource & key to use config if key is nil
    def text_link(resource, show_action = nil)
      if resource.is_a?(String)
        return resource if show_action
        return resource.prepend(collection_prefix)
      end
      if resource[:key].eql?(:id)
      resource[:resource].send(resource[:key])
      else
        resource[:resource].send(resource[:key]).underscore.humanize.pluralize.prepend(collection_prefix)
      end
    end

    def collection_prefix
      "#{Ducktrails.config.collection_prefix} "
    end

    def request_pattern
      @request_pattern ||= Rails.application.routes.recognize_path(current_uri)
    end

    def resource_by_request_pattern
      resources[request_pattern[:controller].split('/').last.to_sym]
    end

    def requested_resource_key
      resource_by_request_pattern[:resource].send(resource_by_request_pattern[:key])
    end

    def split_uri
      current_uri.split('/').reject(&:empty?)
    end
  end
end
