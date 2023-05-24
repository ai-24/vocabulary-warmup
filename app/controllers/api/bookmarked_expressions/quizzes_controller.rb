# frozen_string_literal: true

class Api::BookmarkedExpressions::QuizzesController < ApplicationController
  def show
    @quiz = []

    current_user.bookmarkings.each do |bookmarking|
      expression = Expression.find bookmarking.expression_id
      expression.expression_items.each { |expression_item| @quiz.push expression_item }
    end
  end
end
