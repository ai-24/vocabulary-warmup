# frozen_string_literal: true

class Bookmarking < ApplicationRecord
  belongs_to :user
  belongs_to :expression
end
