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

  describe '#previous' do
    it 'get previous expression' do
      first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      second_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))

      expect(second_expression_items[0].expression.previous).to eq first_expression_items[0].expression
    end

    it 'get previous expression even though the previous id is missing' do
      first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      second_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      third_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))

      second_expression_items[0].expression.destroy

      expect(third_expression_items[0].expression.previous).to eq first_expression_items[0].expression
    end
  end

  describe '.copy_initial_expressions!' do
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user2.id)) }
    let!(:example) { FactoryBot.create(:example, expression_item: second_expression_items[0]) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }

    it 'check if expressions which user_id are nil are copied' do
      expect do
        described_class.copy_initial_expressions!(user.id)
      end.to change(described_class, :count).by(2).and change(ExpressionItem, :count).by(4).and change(Example, :count).by(2)
      expect(described_class.where('user_id = ?', user.id).count).to eq 2
      expect(ExpressionItem.where('content = ?', first_expression_items[0].content).count).to eq 2
      expect(Example.where('content = ?', example.content).count).to eq 1
    end
  end

  describe '.find_expressions_of_users_main_list' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
    end

    it 'return expressions that belongs to the user but does not belong to bookmarking' do
      expect(described_class.find_expressions_of_users_main_list(user.id).count).to eq 1
      expect(described_class.find_expressions_of_users_main_list(user.id)[0].expression_items[0].content).to eq second_expression_items[0].content
    end

    it 'return empty array when none expressions are found' do
      FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
      expect(described_class.find_expressions_of_users_main_list(user.id)).to eq []
    end
  end
end
