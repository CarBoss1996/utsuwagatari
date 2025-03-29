class Owner::PlaceController < Owner::MainController
  def index
    @places = @store.places
  end

  private
  def place_params
    params.require(:place).permit(
      :name,
      :body,
    ).merge(store_id: @store.id)
  end
end
