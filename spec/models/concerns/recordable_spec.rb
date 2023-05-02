# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recordable, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
  let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }

  describe '.create_bookmarkings_or_memorisings!' do
    it 'create bookmarkings' do
      expression_ids = [first_expression_items[0].expression_id, second_expression_items[0].expression_id]
      expect { Bookmarking.create_bookmarkings_or_memorisings!(user.id, expression_ids) }.to change(Bookmarking, :count).by(2)
    end

    it 'create memorisings' do
      expression_ids = [first_expression_items[0].expression_id, second_expression_items[0].expression_id]
      expect { Memorising.create_bookmarkings_or_memorisings!(user.id, expression_ids) }.to change(Memorising, :count).by(2)
    end

    it 'return true' do
      expression_ids = [first_expression_items[0].expression_id, second_expression_items[0].expression_id]
      expect(Bookmarking.create_bookmarkings_or_memorisings!(user.id, expression_ids)).to be true
    end

    it 'return false' do
      expression_ids = [first_expression_items[0].expression_id, second_expression_items[0].expression_id]
      first_expression_items[0].expression.destroy
      expect(Bookmarking.create_bookmarkings_or_memorisings!(user.id, expression_ids)).to be false
    end

    it 'return failure' do
      expression_ids = [first_expression_items[0].expression_id, second_expression_items[0].expression_id]
      first_expression_items[0].expression.destroy
      second_expression_items[0].expression.destroy
      expect(Bookmarking.create_bookmarkings_or_memorisings!(user.id, expression_ids)).to eq 'failure'
    end
  end
end
