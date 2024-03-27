class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :get_user, only: [:show, :edit, :update]

  def index
    @users = User.page(params[:page]).per(25)
  end

  def show ;end

  def edit ;end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "会員情報を更新しました"
    else
      render :edit
    end
  end

  private
  
  def get_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:nickname, :introduction, :email, :profile_image, :is_active)
  end
end
