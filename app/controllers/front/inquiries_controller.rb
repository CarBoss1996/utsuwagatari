class Front::InquiriesController < Front::MainController
  skip_before_action :check_auth, only: [ :new, :confirm, :create ]

  def index
    @inquiries = @store.inquiries.includes(:answers).order(updated_at: :desc)
  end

  def new
    @inquiry = Inquiry.new
  end

  def confirm
    @inquiry = @store.inquiries.new(inquiry_params)
    render :new unless @inquiry.valid?
  end

  def create
    @inquiry = @store.inquiries.new(inquiry_params)
    if @inquiry.save
      redirect_to inquiries_path, notice: "お問い合わせを送信しました"
    else
      render :new
    end
  end

  def read
    inquiry = @store.inquiries.find(params[:id])
    inquiry.answers.where(read_at: nil).update_all(read_at: Time.current)
    head :ok
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :body, :image)
  end
end
