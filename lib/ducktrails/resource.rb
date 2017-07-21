require_relative 'utils/deep_struct'

module Ducktrails
  class Resource
    include Configurable

    attr_reader :resources, :resource, :uri_array, :current_uri

    def initialize(resources, resource, uri_array, current_uri)
      @resources ||= DeepStruct.new(resources)
      @resource ||= resource
      @uri_array ||= uri_array
      @current_uri ||= current_uri
    end

    def link
      if resources.send(resource.to_sym).present?
        return unless resources[resource.to_sym][:policy]
        # Build resource link
        # example /institutions/:institution_id/iterations/:id
        build_link(link_text(resources[resource.to_sym]), progressive_uri)
      elsif index.odd? && resources[uri_array[index - 1].to_sym].present?
        return unless resources[uri_array[index - 1].to_sym][:policy]
        build_link(link_text(resources[uri_array[index - 1].to_sym]), progressive_uri)
      else
        # build links based off of uri
        build_link(link_text(resource.underscore.humanize), progressive_uri)
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

    def progressive_uri
      uri_array[0..index].join('/').prepend('/')
    end

    # TODO factor out the resource & key to use config if key is nil
    # All formatting done here
    def link_text(resource)
      if resource.is_a?(String)
        # TODO Still need to account for edit and new
        return resource if show_action
        return resource.prepend(collection_prefix)
      end

      if resource[:resource].nil?
        return request_pattern[:controller].split('/')[index].underscore.humanize.pluralize.prepend(collection_prefix)
      end

      if show_action
        resource[:resource].send(resource[:key])
      else
        resourcer(resource)
      end
    end

    def resourcer(resource)
      resource = resource[:resource].object if resource[:resource].respond_to?(:object)
      resource.resource.class.name.split('::').first.underscore.humanize.pluralize.prepend(collection_prefix)
    end

    def request_pattern(url = nil)
      @request_pattern ||= Rails.application.routes.recognize_path(url || current_uri)
    end

    # Only describes the CURRRENT PAGE, not the current link state
    def action
      @action ||= request_pattern[:action]
    end

    %w(index show edit new).each do |action_name|
      define_method("#{action_name}_action") do
        request_pattern(progressive_uri)[:action].eql?(action_name)
      end
    end
  end
end
