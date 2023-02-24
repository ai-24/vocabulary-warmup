class CreateWordsAndPhrases < ActiveRecord::Migration[7.0]
  def change
    create_table :words_and_phrases do |t|
      t.text :note

      t.timestamps
    end
  end
end
