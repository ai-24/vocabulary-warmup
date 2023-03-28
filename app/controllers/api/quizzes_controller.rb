# frozen_string_literal: true

class Api::QuizzesController < ApplicationController
  def show
    @quiz = ExpressionItem.all
  end
end
