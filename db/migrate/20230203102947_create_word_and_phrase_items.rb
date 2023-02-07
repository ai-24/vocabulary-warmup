class CreateWordAndPhraseItems < ActiveRecord::Migration[7.0]
  def change
    create_table :word_and_phrase_items do |t|
      t.string :content, null: false
      t.text :explanation, null: false

      t.timestamps
    end
  end
end
