class AddQuantityToTablewares < ActiveRecord::Migration[7.2]
  def change
    add_column :tablewares, :quantity, :integer, after: :body
  end
end
