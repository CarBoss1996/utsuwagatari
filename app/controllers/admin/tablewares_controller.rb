class Admin::TablewaresController < Admin::MainController
  def index
    @pagy, @tablewares = pagy(Tableware.includes(:store).order(created_at: :desc))
  end

  def show
    @tableware = Tableware.includes(:store, :tableware_categories, :histories, :places).find(params[:id])
  end
end
