class Place < ApplicationRecord
  has_many :tableware_places, dependent: :nullify
  has_many :tableware, through: :tableware_places, dependent: :nullify

  validates :name, presence: true
end
