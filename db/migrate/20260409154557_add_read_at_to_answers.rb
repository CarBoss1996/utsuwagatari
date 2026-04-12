class AddReadAtToAnswers < ActiveRecord::Migration[7.2]
  def change
    add_column :answers, :read_at, :datetime, after: :body
  end
end
