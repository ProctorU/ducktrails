class PostsController < ApplicationController
  before_action :find_post, only: %w(show edit)

  def index
  end

  def show
  end

  def edit
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end
end
