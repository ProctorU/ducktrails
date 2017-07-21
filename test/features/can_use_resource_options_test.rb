require 'test_helper'

class CanUseResourceOptionsTest < Capybara::Rails::TestCase
  feature 'with resources given' do
    before(:each) do
      create(:post)
      visit post_path(Post.first)
    end

    test 'assert the collection shows Quacks' do
      assert page.has_content?('All Quacks')
    end
  end
end
