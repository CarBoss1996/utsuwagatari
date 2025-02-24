class CreateHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :histories do |t|
      t.date :entrance_on
      t.date :exit_on
      t.belongs_to :tableware, null: false, foreign_key: true

      t.timestamps
    end
  end
end
