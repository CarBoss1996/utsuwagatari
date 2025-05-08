class TablewareCategory < ApplicationRecord
  belongs_to :tableware
  belongs_to :category
  belongs_to :category_item

  scope :currents, -> { where.not(category_item_id: nil) }

end
