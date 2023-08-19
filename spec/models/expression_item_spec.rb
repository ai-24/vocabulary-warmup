# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpressionItem, type: :model do
  describe '.copy_expression_items!' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }

    it 'check if expression_items are copied' do
      new_expression = Expression.new
      new_expression.note = first_expression_items[0].expression.note
      new_expression.user_id = user.id
      new_expression.save!

      expect { described_class.copy_expression_items!(first_expression_items[0].expression, new_expression) }.to change(described_class, :count).by(2)
      expect(described_class.where(content: first_expression_items[0].content).count).to eq 2
      expect(described_class.where(content: first_expression_items[1].content).count).to eq 2
    end
  end

  describe '.destroy_expression_items' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    it 'check if old expression_item is deleted' do
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              id: first_expression_items[0].id,
              content: first_expression_items[0].content,
              explanation: first_expression_items[0].explanation,
              examples_attributes: { '0' => { content: 'This is an example.' } }
            },
            '1' => {
              id: first_expression_items[1].id,
              content: first_expression_items[1].content,
              explanation: first_expression_items[1].explanation,
              examples_attributes: { '0' => { content: 'This is an example.' } }
            },
            '2' => {
              id: first_expression_items[2].id,
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
      expect { described_class.destroy_expression_items(params, first_expression_items[0].expression) }.to change(described_class, :count).by(-1)
    end
  end
end
