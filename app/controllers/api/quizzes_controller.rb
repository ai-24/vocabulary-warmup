# frozen_string_literal: true

class Api::QuizzesController < ApplicationController
  def show
    @quiz = []

    if logged_in?
      Expression.find_expressions_of_users_main_list(current_user.id).each do |expression|
        expression.expression_items.each { |expression_item| @quiz.push expression_item }
      end
    else
      Expression.where(user_id: nil).each do |expression|
        expression.expression_items.each { |expression_item| @quiz.push expression_item }
      end
    end
  end
end
