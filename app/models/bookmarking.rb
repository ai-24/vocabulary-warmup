# frozen_string_literal: true

class Bookmarking < ApplicationRecord
  belongs_to :user
  belongs_to :expression

  def self.create_all!(user_id, expression_ids)
    bookmarkings = []

    expression_ids.each do |expression_id|
      next if Bookmarking.exists?(user_id:, expression_id:)

      bookmarking = Bookmarking.new
      bookmarking.user_id = user_id
      bookmarking.expression_id = expression_id
      bookmarkings.push(bookmarking)
    end

    return unless bookmarkings.count.positive?

    Bookmarking.transaction do
      bookmarkings.each(&:save!)
    end
  end
end
