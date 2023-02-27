# frozen_string_literal: true

class ExpressionItem < ApplicationRecord
  belongs_to :expression
  has_many :examples, dependent: :destroy
  accepts_nested_attributes_for :examples, reject_if: lambda { |attributes|
    attributes['content'].blank?
  }
end
