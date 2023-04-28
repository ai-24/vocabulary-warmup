# frozen_string_literal: true

class Api::BookmarkingsController < ApplicationController
  def create
    if logged_in?
      Bookmarking.create_bookmarkings_or_memorisings!(current_user.id, bookmarking_params[:expression_id])
      head :no_content
    else
      head :unauthorized
    end
  end

  private

  def bookmarking_params
    params.require(:bookmarking).permit(expression_id: [])
  end
end
