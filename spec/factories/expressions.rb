# frozen_string_literal: true

FactoryBot.define do
  factory :note, class: 'Expression' do
    note { Faker::Quote.famous_last_words }
  end

  factory :empty_note, class: 'Expression' do
    note { '' }
  end
end
