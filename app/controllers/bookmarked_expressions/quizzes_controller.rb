# frozen_string_literal: true

class BookmarkedExpressions::QuizzesController < ApplicationController
  def show
    if logged_in?
      return unless current_user.bookmarkings.count.zero?

      redirect_to bookmarked_expressions_path, notice: t('.no_data')
    else
      redirect_to bookmarked_expressions_path
    end
  end
end
