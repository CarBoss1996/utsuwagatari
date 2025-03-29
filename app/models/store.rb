class Store < ApplicationRecord
  has_many :users, dependent: :destroy

  with_options dependent: :nullify do
    has_many :tablewares
    has_many :categories
    has_many :places
  end

  validates :name, length: { maximum: 20 }

  with_options presence: true do
    validates :name
    validates :active
  end
end
