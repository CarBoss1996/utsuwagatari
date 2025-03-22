class User < ApplicationRecord
  has_secure_password
  belongs_to :store

  validates :name, length: { maximum: 20 }
  validates :password, length: { minimum: 6, maximum: 20 }

  with_options presence: true do
    validates :name
    validates :role
    validates :active
  end

  enum role: [ :user, :store_owner, :admin ]
end
