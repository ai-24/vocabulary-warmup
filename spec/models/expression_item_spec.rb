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
end
