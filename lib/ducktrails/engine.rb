module Ducktrails
  class Engine < ::Rails::Engine
    isolate_namespace Ducktrails
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
