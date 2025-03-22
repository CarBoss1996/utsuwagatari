class AddActiveToStore < ActiveRecord::Migration[7.2]
  def change
    add_column :stores, :active, :boolean, default: true, null: false
  end
end
