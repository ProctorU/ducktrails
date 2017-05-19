module Ducktrails
end

begin
  require 'rails'
rescue LoadError
  #do nothing
end

$stderr.puts <<-EOC if !defined?(Rails)
warning: no framework detected.

Your Gemfile might not be configured properly.
---- e.g. ----
Rails:
    gem 'kaminari'

EOC

require 'ducktrails/config'
require 'ducktrails/engine'
require 'ducktrails/tags'
require 'ducktrails/view_helpers'
