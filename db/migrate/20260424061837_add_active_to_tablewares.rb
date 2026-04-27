class AddActiveToTablewares < ActiveRecord::Migration[7.2]
  def change
    add_column :tablewares, :active, :boolean, default: true, null: false, after: :quantity
  end
end
