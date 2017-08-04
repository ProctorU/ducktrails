require 'test_helper'

class CanSeeShowWithoutResourcesTest < Capybara::Rails::TestCase
  feature 'with no resources given' do
    before(:each) do
      @post = create(:post, title: 'Duck one')
      visit post_path(@post)
      assert page.has_content?('Home')
    end

    test 'assert the collection shows All Posts' do
      assert page.has_content?('All Posts')
    end

    test 'assert the page shows the id' do
      assert page.has_content?(@post.id)
    end
  end
end
