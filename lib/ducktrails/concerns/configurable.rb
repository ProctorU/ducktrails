module Configurable
  include ActiveSupport::Concern
  private

  def collection_prefix
    "#{Ducktrails.config.collection_prefix} "
  end

  def home_name
    Ducktrails.config.home_name
  end
end
