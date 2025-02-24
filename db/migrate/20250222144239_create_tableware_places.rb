class CreateTablewarePlaces < ActiveRecord::Migration[7.2]
  def change
    create_table :tableware_places do |t|
      t.references :tableware, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.date :entrance_on
      t.date :exit_on

      t.timestamps
    end
  end
end
