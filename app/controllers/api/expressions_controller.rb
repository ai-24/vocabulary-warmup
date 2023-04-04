# frozen_string_literal: true

class Api::ExpressionsController < ApplicationController
  before_action :set_expression, only: %i[edit]

  def index
    @expressions = Expression.all
  end

  def edit; end

  private

  def set_expression
    @expression = Expression.find(params[:id])
  end
end
