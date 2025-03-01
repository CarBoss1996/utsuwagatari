class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user_id
      redirect_to stores_path, notice: "ログインしました"
    else
      flash.now[:alert] =  "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    render :new, notice: "ログアウトしました"
  end

  private

  def session_params
    params.require(:session).permit(
      :name,
      :password,
    )
  end
end
