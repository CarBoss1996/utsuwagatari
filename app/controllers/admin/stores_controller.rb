class Admin::StoresController < Admin::MainController
  before_action :set_store, only: [ :show, :edit, :update, :destroy ]
  def index
    @pagy, @stores = pagy(Store.order(:name))
  end

  def show
    @pagy, @tablewares = pagy(@store.tablewares.order(:name))
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

  def destroy
    if @store.destroy
      flash[:notice] = t("helpers.flash.destroyed")
    else
      flash[:alert] = t("helpers.flash.not_destroyed")
    end
    redirect_to admin_stores_path
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
      :tag_name,
      :active,
    )
  end
end
