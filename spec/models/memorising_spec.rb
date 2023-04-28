# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Memorising, type: :model do
  describe 'validation' do
    it 'memorising cannot be saved if same record exists' do
      user = FactoryBot.create(:user)
      expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
      new_memorising = described_class.new(user_id: user.id, expression_id: expression_items[0].expression.id)
      expect(new_memorising).to be_valid

      memorising = FactoryBot.create(:memorising)
      same_memorising = described_class.new(user_id: memorising.user_id, expression_id: memorising.expression_id)
      expect(same_memorising).not_to be_valid
    end
  end
end
