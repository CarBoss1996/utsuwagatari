class History < ApplicationRecord
  belongs_to :tableware
  validates :entrance_on, presence: true
end
