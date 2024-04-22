class User::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_post, only: [:show, :edit, :update, :destroy]
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path(@post), notice: "投稿しました"
    else
      @posts = Post.all
      flash.now[:alert] = "タイトルと本文を入力してください"
      render "new"
    end
  end

  def index
    if params[:tag_id].present?
      @posts = Tag.find(params[:tag_id]).posts
    else
      if params[:user_id]
        @user = User.find(params[:user_id])
        @posts = Post.where(user_id: params[:user_id]).order(created_at: :desc)
      else
        @posts = Post.order(created_at: :desc)
      end
    end

    @posts = @posts.page(params[:page]).per(14)
  end

  def show
    @post_comment = PostComment.new
  end

  def edit; end

  def update
    @post.update(post_params)
    redirect_to post_path(post.id), notice: "投稿内容を変更しました"
  end

  def destroy
    @post.post_comments.destroy_all
    @post.favorites.destroy_all
    @post.tags.destroy_all
    @post.delete
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private
    def get_post
      @post = Post.find(params[:id])
    end

    def is_matching_login_user
      unless @post.user == current_user
      redirect_to post_path
      end
    end

    def post_params
      params.require(:post).permit(:title, :content, tag_ids: [], images: [])
    end
end
