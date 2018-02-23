require 'test_helper'

# Represents an unconfigured resource
# URI with a resource for show/edit and as a nested resource
# need to ensure that each piece of the uri gets a link
module Ducktrails
  class BaseResourceTest < ActiveSupport::TestCase
    test 'pets index' do
      current_uri = 'pets'
      resource = Resource.new(nil, 'pets', current_uri)
      assert_equal 'All Pets', resource.link[:text]
      assert_equal '/pets', resource.link[:uri]
    end

    test 'pets show' do
      current_uri = 'pets/1'
      resource = Resource.new(nil, '1', current_uri)
      assert_equal '1', resource.link[:text]
      assert_equal '/pets/1', resource.link[:uri]
    end

    test 'pets edit' do
      current_uri = 'pets/1/edit'
      resource = Resource.new(nil, 'edit', current_uri)
      assert_equal 'Edit', resource.link[:text]
      assert_equal '/pets/1/edit', resource.link[:uri]
    end

    test 'pets kittens index' do
      current_uri = 'pets/1/kittens'
      resource = Resource.new(nil, 'kittens', current_uri)
      assert_equal 'All Kittens', resource.link[:text]
      assert_equal '/pets/1/kittens', resource.link[:uri]
    end

    test 'pets kittens show' do
      current_uri = 'pets/1/kittens/2'
      resource = Resource.new(nil, '2', current_uri)
      assert_equal '2', resource.link[:text]
      assert_equal '/pets/1/kittens/2', resource.link[:uri]
    end

    test 'pets kittens edit' do
      current_uri = 'pets/1/kittens/2/edit'
      resource = Resource.new(nil, 'edit', current_uri)
      assert_equal 'Edit', resource.link[:text]
      assert_equal '/pets/1/kittens/2/edit', resource.link[:uri]
    end
  end
end
