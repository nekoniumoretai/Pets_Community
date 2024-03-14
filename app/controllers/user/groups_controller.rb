class User::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = cuurent_user.id
    if @group.save
      redirect_to groups_path, method: :post
    else
      render 'new'
    end
  end

  def index
    @groups = Group.all
    @user = User.find(current_user.id)
  end

  def show
    @group = Group.find(params[:id])
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  private

  #作成したグループが current_user.id == owner.idなのかを確認し、他人のグループの編集を行えないようにするメソッド
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end
end
