# frozen_string_literal: true

class Bookmarking < ApplicationRecord
  extend Recordable

  belongs_to :user
  belongs_to :expression
end
