class Owner::SessionsController < Owner::MainController
  def new
  end
  def create
    Rails.logger.debug("ここに注目：#{params.inspect}")
    @user = User.find_by(name: session_params[:name])
    if @user && @user.authenticate(session_params[:password])
      if @user.role == "admin"
        session[:user_id] = @user.id
        redirect_to admin_stores_path, notice: "ログインしました"
      else
        flash[:alert] = "管理者権限がありません"
        redirect_to new_session_path
      end
    else
      flash[:alert] = "こちらからログインしてください"
      redirect_to new_session_path
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
