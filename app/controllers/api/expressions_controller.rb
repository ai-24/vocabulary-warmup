# frozen_string_literal: true

class Api::ExpressionsController < ApplicationController
  def index
    @expressions = Expression.all
  end
end
