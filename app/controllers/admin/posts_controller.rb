class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :get_post, only: [:show, :destroy]

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @posts = Post.where(user_id: params[:user_id]).order(created_at: :desc)
    else
      @posts = Post.order(created_at: :desc)
    end
    @posts = @posts.page(params[:page]).per(25)
  end

  def show ; end

  def destroy
    @post.post_comments.destroy_all
    @post.favorites.destroy_all
    @post.tags.destroy_all
    @post.delete
    redirect_to admin_posts_path, notice: "投稿を削除しました"
  end

  private
    def get_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, tag_ids: [], images: [])
    end
end
