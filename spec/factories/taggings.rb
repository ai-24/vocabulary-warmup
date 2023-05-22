# frozen_string_literal: true

FactoryBot.define do
  factory :tagging do
    tag
    association :expression, factory: :empty_note
  end
end
