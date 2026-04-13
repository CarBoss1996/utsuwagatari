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
    if params.dig(:inquiry, :image).present?
      blob = ActiveStorage::Blob.create_and_upload!(
        io: params[:inquiry][:image],
        filename: params[:inquiry][:image].original_filename,
        content_type: params[:inquiry][:image].content_type
      )
      @image_signed_id = blob.signed_id
    end
    render :new unless @inquiry.valid?
  end

  def create
    @inquiry = @store.inquiries.new(inquiry_params)
    signed_id = params.dig(:inquiry, :image)
    if signed_id.present? && !signed_id.is_a?(ActionDispatch::Http::UploadedFile)
      blob = ActiveStorage::Blob.find_signed(signed_id)
      @inquiry.image.attach(blob) if blob
    end
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
