# frozen_string_literal: true

class Api::QuizzesController < ApplicationController
  before_action :check_xhr_header

  def show
    @quiz = ExpressionItem.all
  end

  private

  def check_xhr_header
    return if request.xhr?

    render json: { error: 'forbidden' }, status: :forbidden
  end
end
