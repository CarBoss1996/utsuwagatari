class Tableware < ApplicationRecord
  has_many_attached :images

  belongs_to :store
  has_many :tableware_places
  has_many :places, through: :tableware_places
  has_many :tableware_categories
  has_many :categories, through: :tableware_categories
  has_many :histories, dependent: :destroy
end
