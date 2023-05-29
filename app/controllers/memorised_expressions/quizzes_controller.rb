# frozen_string_literal: true

class MemorisedExpressions::QuizzesController < ApplicationController
  def show
    if logged_in?
      return unless current_user.memorisings.count.zero?

      redirect_to memorised_expressions_path, notice: t('.no_data')
    else
      redirect_to memorised_expressions_path
    end
  end
end
