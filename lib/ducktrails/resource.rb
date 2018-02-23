require_relative 'utils/deep_struct'
# TODO: below
# 1. Too many conflicting name-spaces remaining from the first version
# 2. Class doesn't do 1 thing
# 3. Some redundancy between methods

module Ducktrails
  class Resource
    include Configurable

    attr_reader :resources, :resource, :current_uri

    def initialize(resources, resource, current_uri)
      @resources = DeepStruct.new(resources)
      @resource = resource
      @current_uri = current_uri
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
        build_link(link_text(resource.underscore.titleize))
      end
    rescue ActionController::RoutingError
      nil
    end

    private

    def split_uri
      @split_uri ||= current_uri.split('/').reject(&:empty?)
    end

    def uri_index
      split_uri.index(resource)
    end

    # TODO: Refactor this to use a resource given by the view_helpers?
    def current_resource
      resources[request_pattern[:controller].split('/').last.to_sym]
    end

    def build_link(text)
      {
        text: text,
        uri: progressive_uri
      }
    end

    def progressive_uri
      split_uri[0..uri_index].join('/').prepend('/')
    end

    def link_text(resource)
      return string_resource if resource.is_a?(String)

      if resource.nil? || resource.resource.nil?
        return resource.as.prepend(col_prefix) unless resource.resource.present? || resource.as.nil?
        return controller_resource_title
      end

      case request_pattern(progressive_uri)[:action]
      when 'show'
        resource[:resource].send(resource[:key])
      when 'edit'
        'Edit ' + resource[:resource].send(resource[:key])
      when 'new'
        'New ' + resourcer(resource.try(:resource)).singularize
      else
        resourcer(resource.try(:resource))
      end
    end

    def string_resource
      return resource.titleize if show_action || edit_action || new_action
      resource.titleize.prepend(col_prefix)
    end

    def resourcer(resource)
      resource.class.name.split('::').first.underscore.titleize.pluralize.prepend(col_prefix)
    end

    def request_pattern(url = nil)
      @request_pattern ||= Rails.application.routes.recognize_path(url || current_uri)
    end

    def controller_resource_title
      return string_resource if request_pattern[:controller].split('/')[uri_index].nil?
      request_pattern[:controller].split('/')[uri_index].underscore.titleize.pluralize.
        prepend(col_prefix)
    end

    def col_prefix
      return '' if new_action || edit_action
      if resources[resource]&.collection_prefix.present?
        resources[resource].collection_prefix.concat(' ')
      else
        collection_prefix
      end
    end

    %w(index show edit new).each do |action_name|
      define_method("#{action_name}_action") do
        request_pattern(progressive_uri)[:action].eql?(action_name)
      end
    end
  end
end
