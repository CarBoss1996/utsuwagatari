class Owner::StoresController < Owner::MainController
  def show
  end

  def edit
  end

  def update
    if @store.update(store_params)
      flash[:notice] = t("helpers.flash.updated")
      redirect_to owner_store_path
    else
      flash[:alert] = t("helpers.flash.not_updated")
      render :edit
    end
  end

  private

  def store_params
    params.require(:store).permit(:name)
  end
end
