# frozen_string_literal: true

class ExpressionItem < ApplicationRecord
  belongs_to :expression
  has_many :examples, dependent: :destroy
  accepts_nested_attributes_for :examples, reject_if: lambda { |attributes|
    attributes['content'].blank?
  }

  def self.copy_expression_items!(expression, new_expression)
    expression.expression_items.order(:created_at, :id).each do |expression_item|
      new_expression_item = ExpressionItem.new
      new_expression_item.content = expression_item.content
      new_expression_item.explanation = expression_item.explanation
      new_expression_item.expression_id = new_expression.id
      new_expression_item.save!

      Example.copy_examples!(expression_item, new_expression_item)
    end
  end
end
