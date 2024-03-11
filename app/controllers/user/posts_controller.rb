class User::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # tag_list = params[:post][:tag_name]
    if @post.save
      # @post.save_tag(tag_list)
      redirect_to posts_path(@post), notice: "投稿しました"
    else
      @posts = Post.all
      render 'new'
    end
  end

  def index
    @tag_list = Tag.all
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])

  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to post_path(post.id), notice: "投稿内容を変更しました"
  end

  def destroy
    post = Post.find(params[:id])
    post.delete
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, tag_ids: [], images: [])
  end
end
