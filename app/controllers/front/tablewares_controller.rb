class Front::TablewaresController < Front::MainController
  before_action :set_tableware, except: [ :index]
  def index
    @tablewares = @store.tablewares
  end

  def show
  end

  def search
  end

  private

  def set_tableware
    @tableware = @store.tablewares.find_by(id: params[:id] || params[:tableware_id])
  end

  def tableware_params
    permitted = params.require(:tableware).permit(
      :name,
      :body,
      :history,
      images: [],
      place_ids: [],
      histories_attributes: [ :id, :entrance_on, :exit_on ],
      tableware_categories_attributes: [ :id, :category_id, :category_item_id, :_destroy ],
    )
    permitted.delete(:images) if permitted[:images]&.all?(&:blank?)
    permitted.merge(store_id: @store.id)
  end
end
