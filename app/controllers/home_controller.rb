# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @expressions = Expression.all
  end
end
