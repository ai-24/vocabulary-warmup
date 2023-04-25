# frozen_string_literal: true

FactoryBot.define do
  factory :bookmarking do
    user
    association :expression, factory: :empty_note
  end
end
