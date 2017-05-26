module Ducktrails
  class Tag
    include ::ActionView::Context

    def initialize(template, options = {})
      @template = template
      @options = options.dup
      @params = template
      @views_prefix = @options.delete(:views_prefix)
    end

    def to_s(locals = {})
      @template.render partial_path, links: locals[:links]
    end

    def partial_path
      [
       'ducktrails',
       self.class.name.demodulize.underscore
      ].compact.join("/")
    end
  end
end
