# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :expressions, through: :taggings

  validates :name, presence: true

  def self.find_tags_object(tags_object)
    tags_object.map { |tag| Tag.find_by(name: tag.name) || tag }
  end
end
