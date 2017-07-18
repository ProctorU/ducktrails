require 'test_helper'

class Ducktrails::Test < ActiveSupport::TestCase
  include Capybara::DSL

  test 'ducktrails exists' do
    assert_kind_of Module, Ducktrails
  end

  # TODO: Complete full testing
  # 1. Test CRUD with no breadcrumbs block given
  # 2. Test CRUD with some resources given
  # 3. Test config options
  test 'render breadcrumb with no setup and no block given' do
    visit '/'
    assert page.has_content?('Home')
  end
end
