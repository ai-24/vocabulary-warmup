# frozen_string_literal: true

class ExpressionItem < ApplicationRecord
  belongs_to :expression
  has_many :examples, dependent: :destroy
end
