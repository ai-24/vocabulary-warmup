# frozen_string_literal: true

class Memorising < ApplicationRecord
  belongs_to :user
  belongs_to :expression
end
