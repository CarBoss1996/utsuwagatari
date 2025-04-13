class Tableware < ApplicationRecord
  has_many_attached :images

  belongs_to :store
  has_many :tableware_places
  has_many :places, through: :tableware_places
  has_many :categories, through: :tableware_categories

  with_options dependent: :destroy do
    has_many :tableware_categories
    has_many :histories
  end

  with_options presence: true do
    validates :name
    validates :body
  end
  accepts_nested_attributes_for :tableware_categories, allow_destroy: true, reject_if: ->(attributes) { attributes["category_item_id"].blank? }
end
