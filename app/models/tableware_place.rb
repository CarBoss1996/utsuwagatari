class TablewarePlace < ApplicationRecord
  belongs_to :tableware
  belongs_to :place

  validates :name, presence: true
end
