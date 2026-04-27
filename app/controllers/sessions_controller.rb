class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      redirect_to stores_path, notice: "ログインしました"
    else
      flash.now[:alert] =  "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    session.delete(:front_user_id)
    redirect_to new_session_path, notice: "ログアウトしました"
  end

  private

  def session_params
    params.require(:session).permit(
      :email,
      :password,
    )
  end
end
