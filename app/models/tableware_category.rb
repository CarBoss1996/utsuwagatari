class TablewareCategory < ApplicationRecord
  belongs_to :tableware
  belongs_to :category
  belongs_to :category_item
end
