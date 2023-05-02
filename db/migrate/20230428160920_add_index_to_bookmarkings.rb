class AddIndexToBookmarkings < ActiveRecord::Migration[7.0]
  def change
    remove_index :bookmarkings, :user_id
    add_index :bookmarkings, [:user_id, :expression_id], unique: true
  end
end
