class User < ApplicationRecord
  include EmailValidatable

  has_secure_password
  belongs_to :store

  validates :password, length: { minimum: 6, maximum: 20 }, if: -> { new_record? || password.present? }

  with_options presence: true do
    validates :name, length: { maximum: 20 }
    validates :role
    # validates :active
  end

  enum role: [ :user, :store_owner, :admin ]
end
