class AddActiveToPlace < ActiveRecord::Migration[7.2]
  def change
    add_column :places, :active, :boolean, default: true, after: :store_id
  end
end
