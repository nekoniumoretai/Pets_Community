class User::PetsController < ApplicationController
  def new
    @pet = Pet.new
  end

  def create
    birthday = "#{params[:pet][:birthday_year]}-#{params[:pet][:birthday_month]}-#{params[:pet][:birthday_day]}"
    params[:pet][:birthday] = birthday
    @pet = Pet.new(pet_params)
    @pet.user_id = current_user.id
    if @pet.save
      redirect_to pets_path(@pet), notice: "登録しました"
    else
      @pets = Pet.all
      render 'new'
    end
  end

  def index
     @pets = Pet.order(created_at: :desc)
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    birthday = "#{params[:pet][:birthday_year]}-#{params[:pet][:birthday_month]}-#{params[:pet][:birthday_day]}"
    params[:pet][:birthday] = birthday
    if @pet.update(pet_params)
      redirect_to pet_path(@pet.id), notice: "登録内容を変更しました"
    else
      render 'edit'
    end
  end

  def destroy
    pet = Pet.find(params[:id])
    pet.delete
    redirect_to pets_path, notice: "情報を削除しました"
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :gender, :birthday, :kind, :introduction, :image)
  end

end
