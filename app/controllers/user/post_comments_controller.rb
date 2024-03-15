class User::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_post, only: [:create, :destroy]

  def create
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    @post_comment = current_user.post_comments.new
     # create.jsとdestroy.jsを一体化させてrenderで呼び出す処理
    render 'user/post_comments/create'
  end

  def destroy
    @post_comment = @post.post_comments.find(params[:id])
    @post_comment.destroy
    render 'user/post_comments/create'
  end

  private

  def get_post
    @post = Post.find(params[:post_id])
  end

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
