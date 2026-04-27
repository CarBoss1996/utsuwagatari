class Owner::SessionsController < Owner::MainController
  skip_before_action :check_auth
  def new
  end
  def create
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password]) && @user.store_id == @store.id
      if @user.role == "admin" || @user.role == "store_owner"
        session[:user_id] = @user.id
        redirect_to owner_tablewares_path, notice: "ログインしました"
      else
        flash[:alert] = "管理者権限がありません"
        redirect_to new_owner_session_path
      end
    else
      flash[:alert] = "こちらからログインしてください"
      redirect_to new_session_path
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_owner_session_path, notice: "ログアウトしました"
  end

  private

  def session_params
    params.require(:session).permit(
      :email,
      :password,
    )
  end
end
