# frozen_string_literal: true

class API::BaseController < ApplicationController
  skip_before_action :store_location
end
