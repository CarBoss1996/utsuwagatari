class Front::PlacesController < Front::MainController
  before_action :set_place, only: [ :show ]

  def index
    @places = @store.places.active
  end

  def show
    @pagy, @tablewares = pagy(@place.tableware)
  end

  private

  def set_place
    @place = @store.places.find(params[:id])
  end
end
