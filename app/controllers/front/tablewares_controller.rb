class Front::TablewaresController < Front::MainController
  before_action :set_tableware, except: [ :index, :search ]

  def index
    @pagy, @tablewares = pagy(@store.tablewares)
    @recently_viewed = @store.tablewares.where(id: recently_viewed_ids).index_by(&:id).values_at(*recently_viewed_ids).compact
  end

  def show
    unless request.headers["X-Sec-Purpose"] == "prefetch" || request.headers["Purpose"] == "prefetch"
      ids = ([ @tableware.id ] + recently_viewed_ids).uniq.first(20)
      session[:recently_viewed] = ids
    end
  end

  def search
    filter = TablewaresFilter.new(@store.tablewares, params)
    @pagy, @tablewares = pagy(filter.call)
    render :index
  end

  private

  def recently_viewed_ids
    session[:recently_viewed] || []
  end

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
