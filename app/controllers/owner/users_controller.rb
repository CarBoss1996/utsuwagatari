class Owner::UsersController < Owner::MainController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  before_action :protect_owner_account, only: [ :update, :destroy ]

  def index
    @users = @store.users.order(created_at: :desc)
  end

  def show
  end

  def new
    @user = @store.users.new
  end

  def create
    @user = @store.users.new(user_params.merge(role: :user))
    if @user.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to owner_users_path
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params.merge(role: :user))
      flash[:notice] = t("helpers.flash.updated")
      redirect_to owner_users_path
    else
      flash[:alert] = t("helpers.flash.not_updated")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = t("helpers.flash.destroyed")
    else
      flash[:alert] = t("helpers.flash.not_destroyed")
    end
    redirect_to owner_users_path
  end

  private

  def set_user
    @user = @store.users.find(params[:id])
  end

  def protect_owner_account
    if @user.store_owner? || @user.admin? || @user == current_user
      flash[:alert] = "この操作は行えません"
      redirect_to owner_users_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :active)
  end
end
