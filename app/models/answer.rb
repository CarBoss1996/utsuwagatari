class Answer < ApplicationRecord
  belongs_to :inquiry

  validates :body, presence: true
end
