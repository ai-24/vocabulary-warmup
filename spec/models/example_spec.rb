# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Example, type: :model do
  describe '.copy_examples!' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:example1) { FactoryBot.create(:example, expression_item: first_expression_items[0]) }
    let!(:example2) { FactoryBot.create(:example, expression_item: first_expression_items[0]) }
    let!(:example3) { FactoryBot.create(:example, expression_item: first_expression_items[0]) }

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
end
