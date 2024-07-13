# frozen_string_literal: true

class QuizzesController < ApplicationController
  def show
    return unless logged_in?

    expressions = Expression.find_expressions_of_users_default_list(current_user)
    return unless expressions.count.zero?

    redirect_to home_path, notice: t('.no_data')
  end
end
