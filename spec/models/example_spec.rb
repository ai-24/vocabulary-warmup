# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Example, type: :model do
  describe '.copy_examples!' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:example1) { FactoryBot.create(:example, expression_item: first_expression_items[0]) }
    let!(:example2) { FactoryBot.create(:example, content: Faker::Quote.yoda, expression_item: first_expression_items[0]) }
    let!(:example3) { FactoryBot.create(:example, content: Faker::Quote.robin, expression_item: first_expression_items[0]) }

    it 'check if examples are copied' do
      new_expression = Expression.new
      new_expression.user_id = user.id
      new_expression.save!

      new_expression_item = ExpressionItem.new
      new_expression_item.content = first_expression_items[0].content
      new_expression_item.explanation = first_expression_items[0].explanation
      new_expression_item.expression_id = new_expression.id
      new_expression_item.save!

      expect(described_class.where(content: example1.content).count).to eq 1
      expect(described_class.where(content: example2.content).count).to eq 1

      expect { described_class.copy_examples!(first_expression_items[0], new_expression_item) }.to change(described_class, :count).by(3)
      expect(described_class.where(content: example1.content).count).to eq 2
      expect(described_class.where(content: example2.content).count).to eq 2
      expect(described_class.where(content: example3.content).count).to eq 2
    end
  end

  describe '.extract_current_examples' do
    it 'check examples of expression' do
      expression = Expression.find 1
      current_examples = [["I'm drying my clothes on the balcony."], ['The postman left my parcel on the veranda.']]
      expect(described_class.extract_current_examples(expression)).to eq current_examples
    end
  end

  describe '.extract_new_examples' do
    it 'check new examples of expression' do
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              id: 1,
              content: 'balcony',
              explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
              examples_attributes: { '0' => { id: 1, content: "I'm drying my clothes on the balcony." }, '1' => { content: 'This is new' } }
            },
            '1' => {
              id: 2,
              content: 'veranda',
              explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
              examples_attributes: { '0' => { id: 2, content: 'The postman left my parcel on the veranda.' } }
            },
            '2' => {
              content: '',
              explanation: '',
              examples_attributes: { '0' => { content: '' }, '1' => { content: '' }, '2' => { content: '' } }
            }
          }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params =
        raw_params.require(:expression).permit(:id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }])
      new_examples = [["I'm drying my clothes on the balcony.", 'This is new'], ['The postman left my parcel on the veranda.'], []]
      expect(described_class.extract_new_examples(params)).to eq new_examples
    end
  end

  describe '.destroy_examples' do
    it 'check if old example is deleted' do
      expression = Expression.find 1
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              id: 1,
              content: 'balcony',
              explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
              examples_attributes: { '0' => { id: 1, content: "I'm drying my clothes on the balcony." } }
            },
            '1' => {
              id: 2,
              content: 'veranda',
              explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
              examples_attributes: { '0' => { id: 2, content: '' } }
            },
            '2' => {
              content: '',
              explanation: '',
              examples_attributes: { '0' => { content: '' }, '1' => { content: '' }, '2' => { content: '' } }
            }
          }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params =
        raw_params.require(:expression).permit(:id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }])
      expect { described_class.destroy_examples(params, expression) }.to change(described_class, :count).by(-1)
    end
  end
end
