# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookmarking, type: :model do
  describe 'validation' do
    it 'bookmarking cannot be saved if same record exists' do
      user = FactoryBot.create(:user)
      expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
      new_memorising = described_class.new(user_id: user.id, expression_id: expression_items[0].expression.id)
      expect(new_memorising).to be_valid

      bookmarking = FactoryBot.create(:bookmarking)
      same_bookmarking = described_class.new(user_id: bookmarking.user_id, expression_id: bookmarking.expression_id)
      expect(same_bookmarking).not_to be_valid
    end
  end
end
