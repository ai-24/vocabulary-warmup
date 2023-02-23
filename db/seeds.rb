# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Expression.create!(note: '')

ExpressionItem.create!(
  [
    {
      content: 'balcony',
      explanation: 'A platform on the side of a building, accessible from inside the building.',
      expression_id: 1
    },
    {
      content: 'Veranda',
      explanation: 'A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
      expression_id: 1
    }
  ]
)

unless Rails.env.test?
  4.times { Expression.create!(note: '') }

  ExpressionItem.create!(
    [
      {
        content: 'journey',
        explanation: 'Travelling but this word means more broad.',
        expression_id: 2
      },
      {
        content: 'trip',
        explanation: 'Travelling to a specific place.',
        expression_id: 2
      },
      {
        content: 'vegetarian',
        explanation: "A person who doesn't eat animals, including meat and fish. Also They don't use animal products where an animal died, such as leather.",
        expression_id: 3
      },
      {
        content: 'Vegan',
        explanation: "A person who doesn't eat, use and have any animal products at all. This includes dairy, eggs and honey.",
        expression_id: 3
      },
      {
        content: 'On the beach',
        explanation: 'This phrase is the location that is on the actual sandy part of the beach.',
        expression_id: 4
      },
      {
        content: 'At the beach',
        explanation: 'This phrase refers to the beach as a general location, so not just the sandy part of the beach but also the shops and restaurants nearby.',
        expression_id: 4
      },
      {
        content: 'Make from',
        explanation: 'Create from a specific material.',
        expression_id: 5
      },
      {
        content: 'Make of',
        explanation: 'Create from the material that itself was created from something else.',
        expression_id: 5
      }
    ]
  )
end
