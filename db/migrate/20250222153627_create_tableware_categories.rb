class CreateTablewareCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :tableware_categories do |t|
      t.belongs_to :tableware, null: false, foreign_key: true
      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :category_item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
