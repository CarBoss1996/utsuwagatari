class Owner::TablewaresController < Owner::MainController
  before_action :set_tableware
  def index
    @tablewares = Tableware.all
  end

  def show
  end

  def new
    @tableware = Tableware.new
  end

  def create
    @tableware = Tableware.new(tableware_params)
    if @tableware.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to owner_tablewares_path
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
  end

  def edit
  end

  def update
    if @tableware.update(tableware_params)
      flash[:notice] = t("helpers.flash.created")
      redirect_to owner_tablewares_path
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :edit
    end
  end

  private

  def set_tableware
    @tableware = Tableware.find_by(id: params[:id])
  end

  def tableware_params
    params.require(:tableware).permit(
      :name,
      :body,
      :images,
      :history,
      tableware_category_ids: [],
      tableware_place_ids: [],
    )
  end
end
