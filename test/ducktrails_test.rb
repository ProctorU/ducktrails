require 'test_helper'

class Ducktrails::Test < ActiveSupport::TestCase
  include Capybara::DSL

  test "ducktrails exists" do
    assert_kind_of Module, Ducktrails
  end

  test 'render breadcrumb with no setup' do

  end
end
