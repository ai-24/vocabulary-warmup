# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :expressions, through: :taggings

  validates :name, presence: true
end
