class Admin::MainController < ApplicationController
  layout "admin/main"
  before_action :check_auth
  helper_method :logged_in?, :current_user

  private
  def current_user
    @current_user ||=User.find(session[:user_id]) if session[:user_id]
  end
  def logged_in?
    !!current_user
  end

  def check_auth
    unless logged_in?
      flash[:alert] = t("helpers.message.not_logged")
      redirect_to new_admin_session_path
      return false
    end

    if @current_user.role != "admin"
      reset_session
      flash[:alert] = t("helpers.message.not_admin")
      redirect_to owner_login_path
      return
    end
  end
end
