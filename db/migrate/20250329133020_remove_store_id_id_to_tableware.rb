class RemoveStoreIdIdToTableware < ActiveRecord::Migration[7.2]
  def change
    remove_column :tablewares, :store_id_id, :bigint
  end
end
