class AddIndexToMemorisings < ActiveRecord::Migration[7.0]
  def change
    remove_index :memorisings, :user_id
    add_index :memorisings, [:user_id, :expression_id], unique: true
  end
end
