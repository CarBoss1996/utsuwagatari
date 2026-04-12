class Front::HomeController < Front::MainController
  skip_before_action :check_auth, only: [ :terms ]

  def index; end
  def terms; end
end
