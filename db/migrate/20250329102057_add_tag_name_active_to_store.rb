class AddTagNameActiveToStore < ActiveRecord::Migration[7.2]
  def change
    add_column :stores, :tag_name, :string, after: :name
    add_column :stores, :active, :boolean, default: false, after: :password_digest

    remove_column :stores, :password_digest, :string
  end
end
