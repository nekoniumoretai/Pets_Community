class User::PetsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_pets, only: [:show, :edit, :update, :destroy]

  def new
    @pet = Pet.new
  end

  def create
    birthday = "#{params[:pet][:birthday_year]}-#{params[:pet][:birthday_month]}-#{params[:pet][:birthday_day]}"
    params[:pet][:birthday] = birthday
    @pet = Pet.new(pet_params)
    @pet.user_id = current_user.id
    if @pet.save
      redirect_to user_pets_path(current_user), notice: "登録しました"
    else
      # @pets = Pet.all
      flash.now[:alert] = "必須項目を入力してください"
      render 'new'
    end
  end

  def index
    @user = User.find(params[:user_id])
    @pets = @user.pets.order(created_at: :desc)
  end

  def show; end

  def edit; end

  def update
    birthday = "#{params[:pet][:birthday_year]}-#{params[:pet][:birthday_month]}-#{params[:pet][:birthday_day]}"
    params[:pet][:birthday] = birthday
    if @pet.update(pet_params)
      redirect_to user_pet_path(@pet.id), notice: "登録内容を変更しました"
    else
      flash.now[:alert] = "必須項目を入力してください"
      render 'edit'
    end
  end

  def destroy
    @pet.delete
    redirect_to user_pets_path(current_user), notice: "情報を削除しました"
  end

  private

  def get_pets
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(:name, :gender, :birthday, :kind, :introduction, :image)
  end

end
