class CreateCategoryItems < ActiveRecord::Migration[7.2]
  def change
    create_table :category_items do |t|
      t.string :name
      t.belongs_to :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
