class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_status, only: [:edit, :update]
  before_action :get_user, only: [:show, :favorites, :groups]
  before_action :ensure_guest_user, only: [:edit]
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page])
  end
  def show
    @get_user = @user.posts.page(params[:page])
    @user_data = @user.my_page_data
    @user_posts = @user.posts.order(created_at: :desc).page(params[:page]).per(20)
    @posts = @user.posts
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました"
    else
      flash.now[:alert] = "ニックネームとメールアドレスを入力してください"
      render "edit"
    end
  end

  def favorites
    favorite_post_ids = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.where(id: favorite_post_ids)
  end

  def groups
    group_user_ids = GroupUser.where(user_id: @user.id).pluck(:group_id)
    owner_group_ids = Group.where(owner_id: @user.id).ids
    @group_users = Group.where(id: group_user_ids + owner_group_ids).order(created_at: :desc)
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

    def is_matching_login_user
      unless @user.id == current_user.id
        redirect_to user_path
      end
    end

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.guest_user?
        redirect_to user_path(current_user), alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      end
    end

    def user_params
      params.require(:user).permit(:nickname, :introduction, :email, :profile_image, :is_active)
    end
end
