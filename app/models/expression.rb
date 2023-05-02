# frozen_string_literal: true

class Expression < ApplicationRecord
  has_many :expression_items, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :bookmarkings, dependent: :destroy
  has_many :users, through: :bookmarkings
  has_many :memorisings, dependent: :destroy
  has_many :users, through: :memorisings
  accepts_nested_attributes_for :expression_items, reject_if: lambda { |attributes|
    attributes['content'].blank?
  }
  accepts_nested_attributes_for :tags

  def previous
    Expression.order(created_at: :desc, id: :desc).find_by('created_at <= ? AND id < ?', created_at, id)
  end

  def next
    Expression.order(:created_at, :id).find_by('created_at >= ? AND id > ?', created_at, id)
  end
end
