class User::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path, notice: "コミュニティを作成しました"
    else
      flash.now[:alert] = "グループ名、グループ紹介文を入力してください"
      render "new"
    end
  end

  def index
    @groups = Group.page(params[:page]).per(12).order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "コミュニティを編集しました"
    else
      flash.now[:alert] = "グループ名、グループ紹介文を入力してください"
      render "edit"
    end
  end

  def destroy
    delete_group = Group.find(params[:id])
    delete_group.destroy
    redirect_to groups_path, notice: "グループを削除しました。"
  end

  private
    # 作成したグループが current_user.id == owner.idなのかを確認し、他人のグループの編集を行えないようにするメソッド
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
