# frozen_string_literal: true

class Api::BookmarkingsController < ApplicationController
  def index
    @bookmarkings = current_user.bookmarkings.order(:created_at, :id)
  end

  def create
    if logged_in?
      result = Bookmarking.create_bookmarkings_or_memorisings!(current_user.id, bookmarking_params[:expression_id])

      if result == 'failure'
        head :unprocessable_entity
      elsif result
        head :no_content
      else
        head :created
      end
    else
      head :unauthorized
    end
  end

  private

  def bookmarking_params
    params.require(:bookmarking).permit(expression_id: [])
  end
end
