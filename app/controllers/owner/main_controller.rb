class Owner::MainController < ApplicationController
  layout "owner/main"
  helper_method :logged_in?, :current_user

  private
  def current_user
    @current_user ||=User.find(session[:user_id]) if session[:user_id]
  end
  def logged_in?
    !!current_user
  end
end
