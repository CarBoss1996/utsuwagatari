class AddStoreIdToPlace < ActiveRecord::Migration[7.2]
  def change
    add_reference :places, :store, foreign_key: true
  end
end
