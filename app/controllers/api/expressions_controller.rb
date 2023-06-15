# frozen_string_literal: true

class Api::ExpressionsController < ApplicationController
  before_action :set_expression, only: %i[edit]

  def index
    @expressions = if logged_in?
                     if params[:search_word]
                       search_words = params[:search_word].split(/[[:blank:]]/)
                       users_expressions = Expression.where(user_id: current_user.id)
                       searched_expressions = search_by_keyword(search_words, users_expressions)
                       searched_expressions[0]
                     else
                       Expression.find_expressions_of_users_main_list(current_user.id)
                     end
                   else
                     Expression.where(user_id: nil)
                   end
  end

  def edit; end

  private

  def set_expression
    @expression = Expression.find(params[:id])
  end

  def search_expressions(expressions, word)
    expressions.ransack(expression_items_content_or_expression_items_explanation_or_note_i_cont: word).result
  end

  def search_tags(expressions, word)
    ids = expressions.map(&:id)
    Expression.joins(:tags).where(id: ids).where('tags.name ILIKE ?', "%#{Tag.sanitize_sql_like(word)}%")
  end

  def remove_duplicate(expressions)
    expression_ids = expressions.uniq.map(&:id)
    Expression.where(id: expression_ids)
  end

  def search_expressions_and_tags(expressions, word)
    searched_expressions = []
    searched_expressions_and_notes = search_expressions(expressions, word).to_a
    searched_expressions.push(*searched_expressions_and_notes) if searched_expressions_and_notes.present?

    new_expressions = search_tags(expressions, word).to_a
    searched_expressions.push(*new_expressions) if new_expressions.present?

    remove_duplicate(searched_expressions) if searched_expressions.present?
  end

  def search_by_keyword(words, users_expressions)
    expressions = []
    expressions.push users_expressions
    words.each do |word|
      next unless expressions[0]

      searched_expressions = search_expressions_and_tags(expressions[0], word)
      expressions.clear
      expressions.push(searched_expressions)
    end
    expressions
  end
end
