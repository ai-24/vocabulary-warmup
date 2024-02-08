# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :store_location, only: [:index]

  def index; end

  def privacy_policy; end

  def terms_of_service; end
end
