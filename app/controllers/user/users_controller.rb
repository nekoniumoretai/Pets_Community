class User::UsersController < ApplicationController

  def show
    @user = current_user
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

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction, :email, :profile_image, :is_active)
  end
end

