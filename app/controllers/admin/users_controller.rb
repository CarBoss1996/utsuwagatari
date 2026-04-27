class Admin::UsersController < Admin::MainController
  before_action :set_store, only: [ :new, :create, :confirm ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @pagy, @stores = pagy(Store.includes(:users).order(:name))
  end

  def show
  end

  def new
    @user = @store.users.new
  end

  def confirm
    @user = @store.users.new(user_params)
  end

  def create
    @user = @store.users.new(user_params)
    if @user.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to admin_store_path(@store)
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t("helpers.flash.updated")
      redirect_to admin_users_path
    else
      flash[:alert] = t("helpers.flash.not_updated")
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = "自分自身は削除できません"
      redirect_to admin_users_path and return
    end
    if @user.destroy
      flash[:notice] = t("helpers.flash.destroyed")
    else
      flash[:alert] = t("helpers.flash.not_destroyed")
    end
    redirect_to admin_users_path
  end

  private

  def set_store
    @store = Store.find_by(id: params[:store_id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :role,
      :active
      )
  end
end
