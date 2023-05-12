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

    Expression.where('user_id = ?', user_id).order(:created_at, :id).each do |expression|
      bookmarked_expression = Bookmarking.find_by(expression_id: expression.id)
      memorised_expression = Memorising.find_by(expression_id: expression.id)

      if !bookmarked_expression && !memorised_expression
        expression = Expression.find expression.id
        expressions.push expression
      end
    end
    expressions
  end

  def previous_bookmarking(expression_id, user)
    bookmarking = Bookmarking.find_by(expression_id:, user_id: user.id)
    previous_bookmarking = user.bookmarkings.order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', bookmarking.created_at, bookmarking.id)
    previous_bookmarking.expression if previous_bookmarking
  end

  def previous_memorising(expression_id, user)
    memorising = Memorising.find_by(expression_id:, user_id: user.id)
    previous_memorising = user.memorisings.order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', memorising.created_at, memorising.id)
    previous_memorising.expression if previous_memorising
  end

  def previous_expression(user)
    if !!user
      previous_expressions = []
      expressions = Expression.find_expressions_of_users_main_list(user.id)
      expressions.each_with_index do |expression, i|
        previous_expressions.push(expressions[i - 1]) if self == expression && i - 1 >= 0
      end
      previous_expressions[0]
    else
      Expression.where(user_id: nil).order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', created_at, id)
    end
  end

  def previous(list, user)
    if list
      if list.match?(/bookmarked_expressions$/)
        previous_bookmarking(id, user)
      elsif list.match?(/memorised_expressions$/)
        previous_memorising(id, user)
      else
        previous_expression(user)
      end
    else
      previous_expression(user)
    end
  end

  def next_bookmarking(expression_id, user)
    bookmarking = Bookmarking.find_by(expression_id:, user_id: user.id)
    next_bookmarking = user.bookmarkings.order(:created_at, :id).find_by('created_at >= ? AND id > ?', bookmarking.created_at, bookmarking.id)
    next_bookmarking.expression if next_bookmarking
  end

  def next_memorising(expression_id, user)
    memorising = Memorising.find_by(expression_id:, user_id: user.id)
    next_memorising = user.memorisings.order(:created_at, :id).find_by('created_at >= ? AND id > ?', memorising.created_at, memorising.id)
    next_memorising.expression if next_memorising
  end

  def next_expression(user)
    if !!user
      next_expressions = []
      expressions = Expression.find_expressions_of_users_main_list(user.id)
      expressions.each_with_index do |expression, i|
        next_expressions.push(expressions[i + 1]) if self == expression
      end
      next_expressions[0]
    else
      Expression.where(user_id: nil).order(:created_at, :id).find_by('created_at >= ? AND id > ?', created_at, id)
    end
  end

  def next(list, user)
    if list
      if list.match?(/bookmarked_expressions$/)
        next_bookmarking(id, user)
      elsif list.match?(/memorised_expressions$/)
        next_memorising(id, user)
      else
        next_expression(user)
      end
    else
      next_expression(user)
    end
  end
end
