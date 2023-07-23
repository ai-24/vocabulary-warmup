# frozen_string_literal: true

Expression.create!(note: '')

ExpressionItem.create!(
  [
    {
      content: 'balcony',
      explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
      expression_id: 1
    },
    {
      content: 'veranda',
      explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
      expression_id: 1
    }
  ]
)

Example.create!(
  [
    {
      content: "I'm drying my clothes on the balcony.",
      expression_item_id: 1
    },
    {
      content: 'The postman left my parcel on the veranda.',
      expression_item_id: 2
    }
  ]
)

unless Rails.env.test?
  8.times { Expression.create!(note: '') }

  ExpressionItem.create!(
    [
      {
        content: 'vegetarian',
        explanation: "(noun) A person who doesn't eat animals, including meat and fish. They also don't use animal products where an animal died, such as leather.",
        expression_id: 2
      },
      {
        content: 'vegan',
        explanation: "(noun) A person who doesn't eat, use and have any animal products at all. This includes dairy, eggs and honey.",
        expression_id: 2
      },
      {
        content: 'on the beach',
        explanation: '(prepositional phrase) This phrase is the location that is on the actual sandy part of the beach.',
        expression_id: 3
      },
      {
        content: 'at the beach',
        explanation: '(prepositional phrase) This phrase refers to the beach as a general location, so not just the sandy part of the beach but also the shops and restaurants nearby.',
        expression_id: 3
      },
      {
        content: 'make from',
        explanation: '(verb + preposition) Create from a specific material.',
        expression_id: 4
      },
      {
        content: 'make of',
        explanation: '(verb + preposition) Create from the material that itself was created from something else.',
        expression_id: 4
      },
      {
        content: 'forgetful',
        explanation: '(adjective) Someone who easily forgets things.',
        expression_id: 5
      },
      {
        content: 'forgettable',
        explanation: '(adjective) Something that can be easily forgotten.',
        expression_id: 5
      },
      {
        content: 'by',
        explanation: '(preposition) An action must be completed at a certain time. ',
        expression_id: 6
      },
      {
        content: 'until',
        explanation: '(preposition, conjunction) You are already doing an action, and you will stop at certain time. ',
        expression_id: 6
      },
      {
        content: 'previous',
        explanation: '(adjective(before noun)) This word refers to the one directly before.',
        expression_id: 7
      },
      {
        content: 'former',
        explanation: '(adjective(before noun)) Something that came before.',
        expression_id: 7
      },
      {
        content: 'manga',
        explanation: '(noun) a story/stories using pictures and text from Japan, or in a Japanese style.',
        expression_id: 8
      },
      {
        content: 'comic',
        explanation: '(noun) a story using pictures and text.',
        expression_id: 8
      },
      {
        content: 'pavement',
        explanation: '(noun) a path on the street next to the road (British English).',
        expression_id: 9
      },
      {
        content: 'sidewalk',
        explanation: '(noun) a path on the street next to the road (American English).',
        expression_id: 9
      }
    ]
  )

  Example.create!(
    [
      {
        content: "Alex is a vegetarian, so he doesn't mind milk in his coffee.",
        expression_item_id: 3
      },
      {
        content: 'Kate is a vegan so she has soy milk in her coffee.',
        expression_item_id: 4
      },
      {
        content: "I'm sitting on the beach.",
        expression_item_id: 5
      },
      {
        content: "I'm meeting my friends at the beach.",
        expression_item_id: 6
      },
      {
        content: 'Houses in Japan are traditionally made from wood.',
        expression_item_id: 7
      },
      {
        content: 'Houses in England are usually made of bricks.',
        expression_item_id: 8
      },
      {
        content: "He didn't bring his gloves, because he's very forgetful.",
        expression_item_id: 9
      },
      {
        content: 'The movie was OK, but rather forgettable.',
        expression_item_id: 10
      },
      {
        content: 'The form must be filled out by Tuesday. Tuesday is the last day to fill out the form.',
        expression_item_id: 11
      },
      {
        content: 'I will work until five.',
        expression_item_id: 12
      },
      {
        content: 'Yoshihide Suga is the previous prime minister (Suga was the PM before the incumbent Kishida).',
        expression_item_id: 13
      },
      {
        content: 'Yukio Hatoyama was a former prime minister (of all people who used to be prime minister, Hatoyama is one).',
        expression_item_id: 14
      },
      {
        content: 'Mike "What manga do you like?" Chris "I enjoy One Piece."',
        expression_item_id: 15
      },
      {
        content: 'Chris "What comics do you enjoy?" Mike "I like Spiderman."',
        expression_item_id: 16
      },
      {
        content: 'Please walk on the pavement.',
        expression_item_id: 17
      },
      {
        content: 'Please walk on the sidewalk.',
        expression_item_id: 18
      }
    ]
  )
end
