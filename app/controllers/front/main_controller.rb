class Front::MainController < ApplicationController
  layout "front/main"
  before_action :set_store
  before_action :store_active?
  before_action :check_auth
  helper_method :logged_in?, :current_user

  private
  def store_active?
    unless @store.active?
      head :not_found
      nil
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:front_user_id]) if session[:front_user_id]
  end

  def logged_in?
    !!current_user
  end

  def check_auth
    unless logged_in?
      flash[:alert] = t("helpers.message.not_logged")
      redirect_to new_session_path
      return false
    end

    unless [ "user", "owner", "admin" ].include?(@current_user.role)
      reset_session
      flash[:alert] = t("helpers.message.not_owner")
      redirect_to new_session_path
      nil
    end
  end
end
