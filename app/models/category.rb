class Category < ApplicationRecord
  has_many :category_items, dependent: :destroy
  has_many :tableware_categories
  has_many :tablewares, through: :tableware_categories
end
