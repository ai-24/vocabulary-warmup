# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tagging, type: :model do
  describe '.destroy_taggings' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:tagging) { FactoryBot.create(:tagging, expression: first_expression_items[0].expression) }

    before do
      FactoryBot.create(:tagging2, expression: first_expression_items[0].expression)
    end

    it 'check if old tagging is deleted' do
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
          },
          tags_attributes: { '0' => { id: tagging.tag.id, name: tagging.tag.name } }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params = raw_params.require(:expression).permit(
        :id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }], tags_attributes: %i[id name]
      )
      expect { described_class.destroy_taggings(params, first_expression_items[0].expression) }.to change(described_class, :count).by(-1)
    end
  end
end
