class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :set_store
  allow_browser versions: :modern unless Rails.env.development?

  private
  def subdomain
    return nil if request.subdomain.blank? || request.subdomain.match(/^www$/)
    _subdomain = request.subdomain.split(".").first
  end

  def store
    return nil if subdomain.blank?
    Store.find_by(tag_name: subdomain) if subdomain.present?
  end

  def set_store
    if store.blank?
      head :not_found
      return false
    end
    @store = store
  end
end
