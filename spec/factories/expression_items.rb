# frozen_string_literal: true

FactoryBot.define do
  factory :expression_item do
    content { Faker::Verb.base }
    explanation { Faker::Quote.famous_last_words }

    association :expression, factory: :note
  end
end
