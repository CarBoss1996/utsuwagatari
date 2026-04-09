class Inquiry < ApplicationRecord
  has_one_attached :image
  belongs_to :store

  validates :name, :email, :body, presence: true
end
