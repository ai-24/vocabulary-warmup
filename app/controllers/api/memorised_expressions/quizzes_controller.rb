# frozen_string_literal: true

class API::MemorisedExpressions::QuizzesController < ApplicationController
  def show
    @quiz = []

    current_user.memorisings.each do |memorising|
      expression = Expression.find memorising.expression_id
      expression.expression_items.order(:created_at, :id).each { |expression_item| @quiz.push expression_item }
    end
  end
end
