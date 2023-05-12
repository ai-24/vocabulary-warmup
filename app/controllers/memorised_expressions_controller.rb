# frozen_string_literal: true

class MemorisedExpressionsController < ApplicationController
  def index
    @memorisings = current_user.memorisings if logged_in?
    session.delete(:forwarding_url)
    store_location
  end
end
