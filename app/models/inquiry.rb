class Inquiry < ApplicationRecord
  has_one_attached :image
  belongs_to :store
  has_many :answers, dependent: :destroy

  enum status: [:pending, :in_progress, :resolved, :not_required]

  validates :name, :body, presence: true
end
