class CategoryItem < ApplicationRecord
  belongs_to :category
  has_many :tableware_categories
end
