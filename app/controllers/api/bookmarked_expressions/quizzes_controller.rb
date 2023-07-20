# frozen_string_literal: true

class API::BookmarkedExpressions::QuizzesController < ApplicationController
  def show
    @quiz = []

    current_user.bookmarkings.each do |bookmarking|
      expression = Expression.find bookmarking.expression_id
      expression.expression_items.order(:created_at, :id).each { |expression_item| @quiz.push expression_item }
    end
  end
end
