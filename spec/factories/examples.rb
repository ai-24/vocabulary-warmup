# frozen_string_literal: true

FactoryBot.define do
  factory :example do
    content { Faker::Quote.jack_handey }
    expression_item
  end
end
