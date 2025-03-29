class Owner::PlacesController < Owner::MainController
  before_action :set_place, except: [ :index, :new, :create ]

  def index
    @places = @store.places
  end

  def show
  end

  def new
    @place = @store.places.new
  end

  def create
    @place = @store.places.new(place_params)
    if @place.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to owner_place_path(@place)
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      flash[:notice] = t("helpers.flash.updated")
      redirect_to owner_place_path(@place)
    else
      flash[:alert] = t("helpers.flash.not_updated")
      render :edit
    end
  end

  def destroy
    if @place.destroy
      flash[:notice] = t("helpers.flash.destroyed")
    else
      flash[:alert] = t("helpers.flash.not_destroyed")
    end
    redirect_to owner_places_path
  end

  private
  def set_place
    @place = @store.places.find_by(id: params[:id])
  end

  def place_params
    params.require(:place).permit(
      :name,
      :body,
    ).merge(store_id: @store.id)
  end
end
