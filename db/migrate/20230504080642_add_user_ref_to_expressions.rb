class AddUserRefToExpressions < ActiveRecord::Migration[7.0]
  def change
    add_reference :expressions, :user, foreign_key: true
  end
end
