class Owner::Categories::ItemsController < Owner::MainController
  before_action :set_category_item, only: [ :edit, :update, :destroy ]
  before_action :set_category, only: [ :new, :create, :edit, :update, :destroy ]
  def new
    @category_item = CategoryItem.new
  end

  def create
    @category_item = CategoryItem.new(category_item_params)
    if @category_item.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to owner_category_path(@category)
    else
      flash[:alert] = t("helpers.flash.not_created")
      render :new
    end
  end

  def edit
  end

  def update
    if @category_item.update(category_item_params)
      @category ||= @category_item.category
      flash[:notice] = t("helpers.flash.updated")
      redirect_to owner_category_path(@category)
    else
      @category ||= @category_item.category
      flash[:alert] = t("helpers.flash.not_updated")
      render :edit
    end
  end

  def destroy
    if @category_item.destroy
      flash[:notice] = t("helpers.flash.destroyed")
    else
      flash[:alert] = t("helpers.flash.not_destroy_deny")
    end
    redirect_to owner_category_path(@category), status: :see_other
  end

  private
  def set_category
    if params[:category_id]
      @category = Category.find_by(id: params[:category_id])
    elsif @category_item.present?
      @category = @category_item.category
    end
  end

  def set_category_item
    @category_item = CategoryItem.find_by(id: params[:id])
  end

  def category_item_params
    params.require(:category_item).permit(:name)
  end
end
