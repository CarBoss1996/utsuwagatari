class Store < ApplicationRecord
  has_secure_password
  has_many :users, dependent: :destroy

  validates :name, length: { maximum: 20 }
  validates :password, length: { minimum: 6, maximum: 20 }

  with_options presence: true do
    validates :name
    validates :active
  end
end
