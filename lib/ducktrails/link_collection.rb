module Ducktrails
  class LinkCollection < Array
    attr_accessor :links

    def initialize(links)
      @links ||= links
    end

    def render_links
    end
  end
end
