# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    uid { Faker::Omniauth.google[:uid] }
    name { Faker::Name.name }
  end
end
