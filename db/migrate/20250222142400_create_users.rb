class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.references :store, null: false, foreign_key: true
      t.string :name
      t.string :password_digest
      t.integer :role, default: 0, null: false
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
