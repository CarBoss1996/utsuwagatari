module EmailValidatable
  extend ActiveSupport::Concern

  included do
    before_validation { self.email = email.strip if email.present? }
    validates :email,
              format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true },
              uniqueness: { case_sensitive: false, scope: :store_id, allow_blank: true }
  end
end
