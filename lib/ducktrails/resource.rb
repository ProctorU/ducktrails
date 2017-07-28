require_relative 'utils/deep_struct'
# TODO: below
# 1. Too many conflicting name-spaces remaining from the first version
# 2. Class doesn't do 1 thing
# 3. Some redundancy between methods

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
      # Build resource link
      # example /institutions/:institution_id/iterations/:id
      if resources.send(resource.to_sym).present?
        return unless resources[resource.to_sym][:policy]
        build_link(link_text(resources[resource.to_sym]))
      elsif (show_action || new_action || edit_action) && current_resource.present?
        return unless current_resource[:policy]
        build_link(link_text(current_resource))
      else
        # build links based off of uri
        build_link(link_text(resource.underscore.humanize))
      end
    end

    private

    def uri_index
      uri_array.index(resource)
    end

    # TODO: Refactor this to use a resource given by the view_helpers?
    def current_resource
      resources[request_pattern[:controller].to_sym]
    end

    def build_link(text)
      {
        text: text,
        uri: progressive_uri
      }
    end

    def progressive_uri
      uri_array[0..uri_index].join('/').prepend('/')
    end

    # TODO factor out the resource & key to use config if key is nil
    # All formatting done here
    def link_text(resource)
      if resource.is_a?(String)
        # TODO Still need to account for edit and new
        return resource if show_action
        return resource.prepend(col_prefix)
      end

      if resource.nil? || resource.resource.nil?
        return resource.as.prepend(col_prefix) unless resource.resource.present? || resource.as.nil?
        return request_pattern[:controller].split('/')[uri_index].underscore.humanize.pluralize.prepend(col_prefix)
      end

      if show_action
        resource[:resource].send(resource[:key])
      else
        resourcer(resource.try(:resource))
      end
    end

    def resourcer(resource)
      # NOTE Accounts for Draper objects
      resource = resource[:resource].object if resource[:resource].respond_to?(:object)
      resource.class.name.split('::').first.underscore.humanize.pluralize.prepend(col_prefix)
    end

    def request_pattern(url = nil)
      @request_pattern ||= Rails.application.routes.recognize_path(url || current_uri)
    end

    def current_action
      @action ||= request_pattern[:action]
    end

    def col_prefix
      return '' if new_action || edit_action
      resources[resource]&.collection_prefix.present? ? resources[resource].collection_prefix.concat(' ') : collection_prefix
    end

    %w(index show edit new).each do |action_name|
      define_method("#{action_name}_action") do
        request_pattern(progressive_uri)[:action].eql?(action_name)
      end
    end
  end
end
