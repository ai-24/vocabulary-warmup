class AddExpressionToExpressionItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :expression_items, :expression, foreign_key: true
  end
end
