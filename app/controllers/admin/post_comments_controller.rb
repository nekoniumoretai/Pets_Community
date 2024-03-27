class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @post_comments = PostComment.page(params[:page]).per(25)
    @users = User.all
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy
    flash[:notice] = "コメントを削除しました"
    redirect_to admin_post_comments_path
  end
end
