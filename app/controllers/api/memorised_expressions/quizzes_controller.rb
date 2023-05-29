# frozen_string_literal: true

class Api::MemorisedExpressions::QuizzesController < ApplicationController
  def show
    @quiz = []

    current_user.memorisings.each do |memorising|
      expression = Expression.find memorising.expression_id
      expression.expression_items.each { |expression_item| @quiz.push expression_item }
    end
  end
end
