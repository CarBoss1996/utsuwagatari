class Owner::AnswersController < Owner::MainController
  before_action :set_inquiry

  def create
    @answer = @inquiry.answers.new(answer_params)
    if @answer.save
      @inquiry.update(updated_at: Time.current)
      flash[:notice] = "返答を追加しました"
    else
      flash[:alert] = "返答を追加できませんでした"
    end
    redirect_to owner_inquiry_path(@inquiry)
  end

  def destroy
    @inquiry.answers.find(params[:id]).destroy
    flash[:notice] = "返答を削除しました"
    redirect_to owner_inquiry_path(@inquiry)
  end

  private

  def set_inquiry
    @inquiry = @store.inquiries.find(params[:inquiry_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
