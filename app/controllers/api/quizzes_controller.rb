# frozen_string_literal: true

class API::QuizzesController < API::BaseController
  def show
    @quiz = []

    if logged_in?
      Expression.find_expressions_of_users_default_list(current_user.id).each do |expression|
        expression.expression_items.order(:created_at, :id).each { |expression_item| @quiz.push expression_item }
      end
    else
      Expression.where(user_id: nil).each do |expression|
        expression.expression_items.order(:created_at, :id).each { |expression_item| @quiz.push expression_item }
      end
    end
  end
end
