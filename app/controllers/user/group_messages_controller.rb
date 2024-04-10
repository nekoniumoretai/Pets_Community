class User::GroupMessagesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @group = Group.find(params[:group_id])

    # グループに参加していない人は見ることができないようにする
    unless @group.owner_id == current_user.id || GroupUser.find_by(group_id: params[:group_id], user_id: current_user.id)
      redirect_to groups_path
    end

    @message = GroupMessage.new
    @messages = GroupMessage.where(group_id: params[:group_id]).order(created_at: :desc)
  end

  def create
    @message = GroupMessage.new(group_message_params)
    if @message.save
      redirect_to new_group_group_message_path(params[:group_id]), notice: '送信しました'
    else
      @group = Group.find(params[:group_id])
      @messages = GroupMessage.where(group_id: params[:group_id]).order(created_at: :desc)
      flash.now[:alert] = '内容を入力してください'
      render :new
    end
  end

  private

  def group_message_params
    params.require(:group_message).permit(:body).merge(group_id: params[:group_id], user_id: current_user.id)
  end
end
