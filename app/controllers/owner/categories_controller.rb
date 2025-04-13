class Owner::CategoriesController < Owner::MainController
  before_action :set_category, except: [ :index ]
  def index
    @categories = @store.category.all
  end

  def show
    @category_items = @category.category_items
  end

  def new
    @category = @store.category.new
  end

  def create
    @category = @store.category.new(category_params)
    if @category.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to owner_categories_path
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = t("helpers.flash.updated")
      redirect_to owner_category_path(@category)
    else
      flash[:alert] = t("helpers.flash.not_updated")
      render :edit
    end
  end

  private
  def set_category
    @category = @store.category.find_by(id: params[:id])
  end

  def category_params
    params.require(:category).permit(
      :name,
    ).merge(store_id: @store.id)
  end
end
