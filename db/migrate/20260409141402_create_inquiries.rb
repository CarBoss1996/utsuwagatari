class CreateInquiries < ActiveRecord::Migration[7.2]
  def change
    create_table :inquiries do |t|
      t.string :name
      t.string :email
      t.text :body
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
