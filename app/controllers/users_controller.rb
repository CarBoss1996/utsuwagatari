class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def confirm
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to "stores/index", notice: "ユーザーを作成しました"
    else
      render :new, alert: "ユーザーの作成に失敗しました"
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :store_id,
      :name,
      :password,
      :role,
      :active,
    )
  end
end
