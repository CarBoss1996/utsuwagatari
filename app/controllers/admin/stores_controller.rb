class Admin::StoresController < Admin::MainController
  before_action :set_store
  def index
    @stores = Store.all
  end

  def show
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to admin_stores_path
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
  end

  def edit
  end

  def update
    if @store.update(store_params)
      flash[:notice] = t("helpers.flash.created")
      redirect_to admin_stores_path
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :edit
    end
  end

  private

  def set_store
    @store = Store.find_by(id: params[:id])
  end

  def store_params
    params.require(:store).permit(
      :name,
      :password,
      :password_confirmation,
      :active,
    )
  end
end
