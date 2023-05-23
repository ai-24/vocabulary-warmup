# frozen_string_literal: true

class QuizzesController < ApplicationController
  def show
    return unless logged_in?

    expressions = Expression.find_expressions_of_users_main_list(current_user.id)
    return unless expressions.count.zero?

    redirect_to root_path, notice: t('.no_data')
  end
end
