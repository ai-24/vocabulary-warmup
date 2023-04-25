class CreateBookmarkings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarkings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :expression, null: false, foreign_key: true

      t.timestamps
    end
  end
end
