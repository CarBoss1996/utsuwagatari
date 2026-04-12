class Admin::AnswersController < Admin::MainController
  before_action :set_inquiry

  def create
    @answer = @inquiry.answers.new(answer_params)
    if @answer.save
      @inquiry.touch
      flash[:notice] = "返答を追加しました"
    else
      flash[:alert] = "返答を追加できませんでした"
    end
    redirect_to admin_inquiry_path(@inquiry)
  end

  def destroy
    @inquiry.answers.find(params[:id]).destroy
    flash[:notice] = "返答を削除しました"
    redirect_to admin_inquiry_path(@inquiry)
  end

  private

  def set_inquiry
    @inquiry = Inquiry.find(params[:inquiry_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
