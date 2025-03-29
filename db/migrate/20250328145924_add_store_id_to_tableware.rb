class AddStoreIdToTableware < ActiveRecord::Migration[7.2]
  def change
    add_reference :tablewares, :store, foreign_key: true
  end
end
