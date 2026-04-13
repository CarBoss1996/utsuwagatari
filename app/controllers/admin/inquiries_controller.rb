class Admin::InquiriesController < Admin::MainController
  before_action :set_inquiry, only: [ :show, :update ]

  def index
    @inquiries = Inquiry.includes(:store).order(updated_at: :desc)
  end

  def show
  end

  def update
    if @inquiry.update(inquiry_params)
      flash[:notice] = t("helpers.flash.updated")
    else
      flash[:alert] = t("helpers.flash.not_updated")
    end
    redirect_to admin_inquiry_path(@inquiry)
  end

  private

  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end

  def inquiry_params
    params.require(:inquiry).permit(:status, :memo)
  end
end
