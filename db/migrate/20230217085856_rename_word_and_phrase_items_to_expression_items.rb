class RenameWordAndPhraseItemsToExpressionItems < ActiveRecord::Migration[7.0]
  def change
    rename_table :word_and_phrase_items, :expression_items
  end
end
