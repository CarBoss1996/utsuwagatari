class Owner::PlaceController < Owner::MainController
  def index
    @places = @store.places
  end
end
