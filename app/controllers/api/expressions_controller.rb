# frozen_string_literal: true

class Api::ExpressionsController < ApplicationController
  before_action :set_expression, only: %i[edit]

  def index
    @expressions = if logged_in?
                     Expression.find_expressions_of_users_main_list(current_user.id)
                   else
                     Expression.where(user_id: nil)
                   end
  end

  def edit; end

  private

  def set_expression
    @expression = Expression.find(params[:id])
  end
end
