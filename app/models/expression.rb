# frozen_string_literal: true

class Expression < ApplicationRecord
  has_many :expression_items, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :bookmarkings, dependent: :destroy
  has_many :users, through: :bookmarkings
  has_many :memorisings, dependent: :destroy
  has_many :users, through: :memorisings
  belongs_to :user, optional: true

  accepts_nested_attributes_for :expression_items, reject_if: lambda { |attributes|
    attributes['content'].blank?
  }
  accepts_nested_attributes_for :tags

  def self.ransackable_associations(_auth_object = nil)
    %w[expression_items]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[note]
  end

  def bookmarking?
    !!Bookmarking.find_by(expression_id: id, user_id:)
  end

  def memorising?
    !!Memorising.find_by(expression_id: id, user_id:)
  end

  def self.copy_initial_expressions!(user_id)
    Expression.where(user_id: nil).find_each do |expression|
      new_expression = Expression.new
      new_expression.note = expression.note
      new_expression.user_id = user_id
      new_expression.save!

      ExpressionItem.copy_expression_items!(expression, new_expression)
    end
  end

  def self.find_expressions_of_users_default_list(user_id)
    expressions = []

    Expression.where('user_id = ?', user_id).order(:created_at, :id).each do |expression|
      next unless !expression.bookmarking? && !expression.memorising?

      expressions.push(Expression.find(expression.id))
    end
    expressions
  end

  def previous_bookmarking(expression_id, user)
    bookmarking = Bookmarking.find_by(expression_id:, user_id: user.id)
    previous_bookmarking = user.bookmarkings.order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', bookmarking.created_at, bookmarking.id)
    previous_bookmarking&.expression
  end

  def previous_memorising(expression_id, user)
    memorising = Memorising.find_by(expression_id:, user_id: user.id)
    previous_memorising = user.memorisings.order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', memorising.created_at, memorising.id)
    previous_memorising&.expression
  end

  def previous_expression(user)
    if !!user
      previous_expressions = []
      expressions = Expression.find_expressions_of_users_default_list(user.id)
      expressions.each_with_index do |expression, i|
        previous_expressions.push(expressions[i - 1]) if self == expression && i - 1 >= 0
      end
      previous_expressions[0]
    else
      Expression.where(user_id: nil).order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', created_at, id)
    end
  end

  def previous(user)
    if bookmarking?
      previous_bookmarking(id, user)
    elsif memorising?
      previous_memorising(id, user)
    else
      previous_expression(user)
    end
  end

  def next_bookmarking(expression_id, user)
    bookmarking = Bookmarking.find_by(expression_id:, user_id: user.id)
    next_bookmarking = user.bookmarkings.order(:created_at, :id).find_by('created_at >= ? AND id > ?', bookmarking.created_at, bookmarking.id)
    next_bookmarking&.expression
  end

  def next_memorising(expression_id, user)
    memorising = Memorising.find_by(expression_id:, user_id: user.id)
    next_memorising = user.memorisings.order(:created_at, :id).find_by('created_at >= ? AND id > ?', memorising.created_at, memorising.id)
    next_memorising&.expression
  end

  def next_expression(user)
    if !!user
      next_expressions = []
      expressions = Expression.find_expressions_of_users_default_list(user.id)
      expressions.each_with_index do |expression, i|
        next_expressions.push(expressions[i + 1]) if self == expression
      end
      next_expressions[0]
    else
      Expression.where(user_id: nil).order(:created_at, :id).find_by('created_at >= ? AND id > ?', created_at, id)
    end
  end

  def next(user)
    if bookmarking?
      next_bookmarking(id, user)
    elsif memorising?
      next_memorising(id, user)
    else
      next_expression(user)
    end
  end

  def destroy_expression_items(params)
    current_expression_items = expression_items.map(&:content)
    new_expression_items = params[:expression_items_attributes].to_h.map { |expression_item| expression_item[1][:content].presence }.compact
    return unless current_expression_items.count > new_expression_items.count

    delete_expression_items = current_expression_items.difference(new_expression_items)
    delete_expression_items.each { |expression_item| ExpressionItem.find_by(content: expression_item, expression_id: id)&.destroy }
  end

  def extract_current_examples
    expression_items.map { |expression_item| expression_item.examples.map(&:content) }
  end

  def self.extract_new_examples(params)
    params[:expression_items_attributes].to_h.map do |expression_item|
      expression_item[1][:examples_attributes].map { |example| example[1][:content].presence }.compact
    end
  end

  def destroy_examples(params)
    current_examples = extract_current_examples
    new_examples = Expression.extract_new_examples(params)
    current_examples.zip(new_examples) do |current_examples_of_expression_item, new_examples_of_expression_item|
      next unless current_examples_of_expression_item.count > new_examples_of_expression_item.count

      delete_examples = current_examples_of_expression_item.difference(new_examples_of_expression_item)
      delete_examples.each do |example|
        expression_items.each { |expression_item| Example.find_by(content: example, expression_item_id: expression_item.id)&.destroy }
      end
    end
  end

  def find_tags_object
    tags.map { |tag| Tag.find_by(name: tag.name) || tag }
  end

  def destroy_taggings(params)
    current_tags = tags.map(&:name)
    new_tags = params[:tags_attributes].to_h.map { |tag| tag[1][:name] }
    delete_tag_names = current_tags.difference(new_tags)
    delete_tags = Tag.where(name: delete_tag_names)
    delete_tags.each { |tag| Tagging.find_by(tag:, expression: self)&.destroy }
  end
end
