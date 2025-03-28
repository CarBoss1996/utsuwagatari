class Admin::UsersController < Admin::MainController
  before_action :set_store
  before_action :set_user, only: %i[edit update]

  def new
    @user = @store.users.new
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
      flash[:notice] = t("helpers.flash.created")
      redirect_to admin_store_path(@store)
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
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
      :password,
      :password_confirmation,
      :role,
      :active,
    )
  end
end
