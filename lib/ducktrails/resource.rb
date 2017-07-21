module Ducktrails
  class Resource
    include Configurable

    attr_reader :resources, :resource, :uri_array, :current_uri

    def initialize(resources, resource, uri_array, current_uri)
      @resources ||= resources
      @resource ||= resource
      @uri_array ||= uri_array
      @current_uri ||= current_uri
    end

    def link
      if resources[resource.to_sym].present?
        return unless resources[resource.to_sym][:policy]
        # Build resource link
        # example /institutions/:institution_id/iterations/:id
        build_link(text_link(resources[resource.to_sym], index.odd?), uri_array[0..index].join('/').prepend('/'))
      elsif index.odd? && resources[uri_array[index - 1].to_sym].present?
        return unless resources[uri_array[index - 1].to_sym][:policy]
        build_link(text_link(resources[uri_array[index - 1].to_sym], index.odd?), uri_array[0..index].join('/').prepend('/'))
      else
        # build links based off of uri
        build_link(text_link(resource.underscore.humanize, index.odd?), uri_array[0..index].join('/').prepend('/'))
      end
    end

    private

    def index
      uri_array.index(resource)
    end

    def build_link(text, uri)
      {
        text: text,
        uri: uri
      }
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

    def action
      @action ||= request_pattern[:action]
    end
  end
end
