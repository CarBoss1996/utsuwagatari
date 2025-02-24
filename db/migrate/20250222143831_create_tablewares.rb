class CreateTablewares < ActiveRecord::Migration[7.2]
  def change
    create_table :tablewares do |t|
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
