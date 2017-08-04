require 'test_helper'

class CanSeeEditWithoutResourcesTest < Capybara::Rails::TestCase
  feature 'with no resources given' do
    before(:each) do
      @post = create(:post, title: 'Duck edit')
      visit edit_post_path(@post)
      assert page.has_content?('Home')
    end

    test 'assert the page shows other links' do
      assert page.has_content?('All Posts')
      assert page.has_content?(@post.id)
    end

    test 'assert the page shows the edit link' do
      assert page.has_content?('edit')
    end
  end
end
