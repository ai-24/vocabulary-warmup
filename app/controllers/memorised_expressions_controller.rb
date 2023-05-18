# frozen_string_literal: true

class MemorisedExpressionsController < ApplicationController
  def index
    @memorisings = current_user.memorisings if logged_in?
    store_list
    store_location
  end
end
