require 'test_helper'

class Ducktrails::Test < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test 'ducktrails exists' do
    assert_kind_of Module, Ducktrails
  end

  # TODO: Complete full testing
  # 1. Test CRUD with no breadcrumbs block given
  # 2. Test CRUD with some resources given
  # 3. Test config options
  test 'render breadcrumb' do
    visit '/'
    assert page.has_content?('Home')
  end

  test 'render collection bredcrumb' do
    visit posts_path
    assert page.has_content?('Home')
    assert page.has_content?('All Posts')
  end
end
