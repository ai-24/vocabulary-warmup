# frozen_string_literal: true

FactoryBot.define do
  factory :expression_item do
    content { Faker::Verb.base }
    explanation { Faker::Quote.famous_last_words }

    association :expression, factory: :note
  end

  factory :expression_item2, class: 'ExpressionItem' do
    content { Faker::Verb.base }
    explanation { Faker::Quote.matz }

    association :expression, factory: :note
  end

  factory :expression_item3, class: 'ExpressionItem' do
    content { Faker::Verb.base }
    explanation { Faker::Quote.jack_handey }

    association :expression, factory: :note
  end

  factory :expression_item4, class: 'ExpressionItem' do
    content { Faker::Verb.base }
    explanation { Faker::Quote.most_interesting_man_in_the_world }

    association :expression, factory: :note
  end

  factory :expression_item5, class: 'ExpressionItem' do
    content { Faker::Verb.base }
    explanation { Faker::Quote.robin }

    association :expression, factory: :note
  end

  factory :expression_item6, class: 'ExpressionItem' do
    content { Faker::Verb.base }
    explanation { Faker::Quotes::Shakespeare.hamlet_quote }

    association :expression, factory: :note
  end
end
