# frozen_string_literal: true

class Expression < ApplicationRecord
  has_many :expression_items, dependent: :destroy
  accepts_nested_attributes_for :expression_items, reject_if: lambda { |attributes|
    attributes['content'].blank?
  }
end
