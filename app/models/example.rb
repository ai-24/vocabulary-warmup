# frozen_string_literal: true

class Example < ApplicationRecord
  belongs_to :expression_item

  def self.copy_examples!(expression_item, new_expression_item)
    expression_item.examples.each do |example|
      new_example = Example.new
      new_example.content = example.content
      new_example.expression_item_id = new_expression_item.id
      new_example.save!
    end
  end
end
