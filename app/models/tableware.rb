class Tableware < ApplicationRecord
  has_many_attached :images

  belongs_to :store
  has_many :tableware_places
  has_many :places, through: :tableware_places
  has_many :categories, through: :tableware_categories

  with_options dependent: :destroy do
    has_many :tableware_categories
    has_many :histories
  end

  with_options presence: true do
    validates :name
  end
  accepts_nested_attributes_for :histories
  accepts_nested_attributes_for :tableware_categories, allow_destroy: true, reject_if: ->(attributes) { attributes["category_item_id"].blank? }

  def categories_info
    self.tableware_categories.currents.map do |tc|
      "#{tc.category.name}：#{tc.category_item.name}"
    end.join("<br>").html_safe
  end

  def places_info
    self.places.map(&:name).join("、")
  end

  def histories_info
    self.histories.map do |history|
      "#{history.entrance_on}〜#{history.exit_on}"
    end.join("<br>").html_safe
  end
end
