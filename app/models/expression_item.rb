# frozen_string_literal: true

class ExpressionItem < ApplicationRecord
  belongs_to :expression
  has_many :examples, dependent: :destroy
  accepts_nested_attributes_for :examples, reject_if: lambda { |attributes|
    attributes['content'].blank?
  }

  def self.ransackable_associations(_auth_object = nil)
    %w[expression]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[content explanation]
  end

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

  def self.destroy_expression_items(params, expression)
    current_expression_items = expression.expression_items.map(&:content)
    new_expression_items = params[:expression_items_attributes].to_h.map { |expression_item| expression_item[1][:content].presence }.compact
    return unless current_expression_items.count > new_expression_items.count

    delete_expression_items = current_expression_items.difference(new_expression_items)
    delete_expression_items.each { |expression_item| ExpressionItem.find_by(content: expression_item, expression_id: expression.id)&.destroy }
  end
end
