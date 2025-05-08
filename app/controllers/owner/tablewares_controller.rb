class Owner::TablewaresController < Owner::MainController
  before_action :set_tableware, except: [ :index, :new, :create ]
  before_action :set_category_items, only: [ :new, :edit ]
  def index
    @tablewares = @store.tablewares
  end

  def show
  end

  def new
    @tableware = @store.tablewares.new
  end

  def create
    @tableware = @store.tablewares.new(tableware_params)
    if @tableware.save
      flash[:notice] = t("helpers.flash.created")
      redirect_to owner_tablewares_path
    else
      set_category_items
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
      set_category_items
      flash[:alert] = t("helpers.flash.not_created")
      render :edit
    end
  end

  def destroy
    if @tableware.destroy
      flash[:notice] = t("helpers.flash.destroyed", model: Tableware.model_name.human)
      redirect_to owner_tablewares_path
    else
      flash[:alert] = t("helpers.flash.destroy_deny", model: Tableware.model_name.human)
      render :show
    end
  end

  def image_upload
    if params[:images].present?
      params[:images].each do |img|
        @tableware.images.attach(img)
      end
      flash[:notice] = t("helpers.flash.created", model: Tableware.model_name.human)
    else
      flash[:notice] = t("helpers.flash.not_created", model: Tableware.model_name.human)
    end
    redirect_to owner_tableware_path(@tableware)
  end

  def image_destroy
    @image = @tableware.images.find(params[:image_id])
    if @image.purge
      flash[:notice] = t("helpers.flash.destroyed", model: "画像")
    else
      flash[:alert] = t("helpers.flash.destroy_deny", model: "画像")
    end
    redirect_to owner_tableware_path(@tableware)
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

  def set_category_items
    @tableware ||= @store.tablewares.new
    @categories = @store.categories.includes(:category_items)
    @categories.each do |category|
      @tableware.tableware_categories.build(category: category)
    end
    # @category_items = @store.categories.includes(:category_items).each_with_object({}) do |category, hash|
    #   hash[category.id] = category.category_items.map{|item|{id: item.id, name: item.name}}
    # end
  end
end
