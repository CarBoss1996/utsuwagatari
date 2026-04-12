class Owner::InquiriesController < Owner::MainController
  before_action :set_inquiry, only: [ :show, :update ]

  def index
    @inquiries = @store.inquiries.order(created_at: :desc)
  end

  def show
  end

  def update
    if @inquiry.update(inquiry_params)
      flash[:notice] = t("helpers.flash.updated")
      redirect_to owner_inquiry_path(@inquiry)
    else
      flash[:alert] = t("helpers.flash.not_updated")
      render :show
    end
  end

  private

  def set_inquiry
    @inquiry = @store.inquiries.find(params[:id])
  end

  def inquiry_params
    params.require(:inquiry).permit(:status, :memo)
  end
end
