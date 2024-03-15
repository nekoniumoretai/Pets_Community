class Admin::PostCommentsController < ApplicationController

  def index
    @post_comments = PostComment.all
    @users = User.all
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy
    flash[:notice] = "コメントを削除しました"
    redirect_to admin_post_comments_path
  end
end