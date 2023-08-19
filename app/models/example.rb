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

  def self.extract_current_examples(expression)
    expression.expression_items.map { |expression_item| expression_item.examples.map(&:content) }
  end

  def self.extract_new_examples(params)
    params[:expression_items_attributes].to_h.map do |expression_item|
      expression_item[1][:examples_attributes].map { |example| example[1][:content].presence }.compact
    end
  end

  def self.destroy_examples(params, expression)
    current_examples = extract_current_examples(expression)
    new_examples = extract_new_examples(params)
    current_examples.zip(new_examples) do |current_examples_of_expression_item, new_examples_of_expression_item|
      next unless current_examples_of_expression_item.count > new_examples_of_expression_item.count

      delete_examples = current_examples_of_expression_item.difference(new_examples_of_expression_item)
      delete_examples.each do |example|
        expression.expression_items.each { |expression_item| Example.find_by(content: example, expression_item_id: expression_item.id)&.destroy }
      end
    end
  end
end
