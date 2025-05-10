class Front::SessionsController < Front::MainController
  skip_before_action :check_auth, only: [ :new, :create ]
  def new
  end

  def create
    @user = User.find_by(name: session_params[:name])
    if @user && @user.authenticate(session_params[:password]) && @user.store_id == @store.id
      session[:front_user_id] = @user.id
      redirect_to tablewares_path, notice: "ログインしました"
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
      :name,
      :password,
    )
  end
end
