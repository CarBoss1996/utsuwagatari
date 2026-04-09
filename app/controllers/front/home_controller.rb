class Front::HomeController < Front::MainController
  skip_before_action :check_auth, only: [ :terms, :inquiry, :create_inquiry ]

  def index; end
  def terms; end

  def inquiry
    @inquiry = Inquiry.new
  end

  def create_inquiry
    @inquiry = @store.inquiries.new(inquiry_params)
    if @inquiry.save
      redirect_to inquiry_path, notice: "お問い合わせを送信しました"
    else
      render :inquiry
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :body, :image)
  end
end
