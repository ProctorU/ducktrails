require 'test_helper'

class CanSeeIndexWithoutResourcesTest < Capybara::Rails::TestCase
  feature 'with no resources given' do
    before(:each) do
      @post = create(:post)
      visit posts_path
      assert page.has_content?('Home')
    end

    test 'assert the collection shows All Posts' do
      assert page.has_content?('All Posts')
    end
  end
end
