# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expression, type: :model do
  describe '#next' do
    it 'get next expression' do
      first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      second_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))

      expect(first_expression_items[0].expression.next).to eq second_expression_items[0].expression
    end

    it 'get next expression even though the next id is missing' do
      first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      second_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      third_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))

      second_expression_items[0].expression.destroy

      expect(first_expression_items[0].expression.next).to eq third_expression_items[0].expression
    end
  end
end
