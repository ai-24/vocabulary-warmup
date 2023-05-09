# frozen_string_literal: true

class Expression < ApplicationRecord
  has_many :expression_items, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :bookmarkings, dependent: :destroy
  has_many :users, through: :bookmarkings
  has_many :memorisings, dependent: :destroy
  has_many :users, through: :memorisings
  accepts_nested_attributes_for :expression_items, reject_if: lambda { |attributes|
    attributes['content'].blank?
  }
  accepts_nested_attributes_for :tags

  def self.copy_initial_expressions!(user_id)
    Expression.where(user_id: nil).find_each do |expression|
      new_expression = Expression.new
      new_expression.note = expression.note
      new_expression.user_id = user_id
      new_expression.save!

      expression.expression_items.each do |expression_item|
        new_expression_item = ExpressionItem.new
        new_expression_item.content = expression_item.content
        new_expression_item.explanation = expression_item.explanation
        new_expression_item.expression_id = new_expression.id
        new_expression_item.save!

        expression_item.examples.each do |example|
          new_example = Example.new
          new_example.content = example.content
          new_example.expression_item_id = new_expression_item.id
          new_example.save!
        end
      end
    end
  end

  def self.find_expressions_of_users_main_list(user_id)
    expressions = []

    Expression.where('user_id = ?', user_id).order(:created_at).each do |expression|
      bookmarked_expression = Bookmarking.find_by(expression_id: expression.id)

      unless bookmarked_expression
        expression = Expression.find expression.id
        expressions.push expression
      end
    end
    expressions
  end

  def previous
    Expression.order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', created_at, id)
  end

  def next
    Expression.order(:created_at, :id).find_by('created_at >= ? AND id > ?', created_at, id)
  end
end
