# frozen_string_literal: true

FactoryBot.define do
  factory :tagging do
    tag
    association :expression, factory: :empty_note
  end

  factory :tagging2, class: 'Tagging' do
    association :tag, name: '2023'
    association :expression, factory: :empty_note
  end
end
