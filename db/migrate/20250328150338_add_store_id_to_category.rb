class AddStoreIdToCategory < ActiveRecord::Migration[7.2]
  def change
    add_reference :categories, :store, foreign_key: true
  end
end
