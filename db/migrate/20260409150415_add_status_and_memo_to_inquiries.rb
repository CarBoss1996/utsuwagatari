class AddStatusAndMemoToInquiries < ActiveRecord::Migration[7.2]
  def change
    add_column :inquiries, :status, :integer, default: 0, null: false
    add_column :inquiries, :memo, :text
  end
end
