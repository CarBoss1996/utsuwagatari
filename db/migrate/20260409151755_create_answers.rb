class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.references :inquiry, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
