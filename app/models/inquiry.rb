class Inquiry < ApplicationRecord
  has_one_attached :image
  belongs_to :store
  has_many :answers, dependent: :destroy

  enum status: { pending: 0, in_progress: 1, not_required: 2 }

  validates :name, :body, presence: true
end
