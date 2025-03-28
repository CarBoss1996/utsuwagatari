class Owner::CategoriesController < Owner::MainController
  before_action :set_category, except: [ :index ]
  def index
    @categories = Category.all
  end

  def show
    @category_items = @category.category_items
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
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
    @category = Category.find_by(id: params[:id])
  end

  def category_params
    params.require(:category).permit(
      :name,
    )
  end
end
