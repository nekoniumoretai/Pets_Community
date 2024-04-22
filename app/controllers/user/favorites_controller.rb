class User::FavoritesController < ApplicationController
  before_action :get_post, only: [:create, :destroy]

  def create
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
  end

  def destroy
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end

def get_post
  @post = Post.find(params[:post_id])
end
