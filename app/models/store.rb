class Store < ApplicationRecord
  has_one_attached :floor_map
  has_many :users, dependent: :destroy
  has_many :inquiries, dependent: :destroy

  with_options dependent: :nullify do
    has_many :tablewares
    has_many :categories
    has_many :places
  end

  validates :name, length: { maximum: 20 }

  with_options presence: true do
    validates :name
    validates :tag_name
  end
  # validates :active, inclusion: { in: [ true, false ] }
end
