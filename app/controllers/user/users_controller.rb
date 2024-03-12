class User::UsersController < ApplicationController
  before_action :check_user_status, only: [:edit, :update]
  before_action :get_user, only: [:show, :favorites]

  def index
    @users = User.all
  end
  def show
    @users = User.all
    @user_data = @user.my_page_data
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました"
    else
      render 'edit'
    end
  end

  def favorites
    favorite_post_ids = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.where(id: favorite_post_ids)
  end


  private

  def check_user_status
    @user = User.find(params[:id])
    if @user.is_active == false
      redirect_to root_path, alert: "このアカウントは停止されています。"
    end
  end

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname, :introduction, :email, :profile_image, :is_active)
  end
end

