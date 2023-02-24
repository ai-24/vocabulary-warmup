class CreateExpressions < ActiveRecord::Migration[7.0]
  def change
    create_table :expressions do |t|
      t.text :note

      t.timestamps
    end
  end
end
