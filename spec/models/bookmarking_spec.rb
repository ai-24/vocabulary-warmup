# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookmarking, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
  let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
  let!(:bookmarking) { FactoryBot.create(:bookmarking) }

  describe '.create_all!' do
    it 'create bookmarkings' do
      expression_ids = [first_expression_items[0].expression_id, second_expression_items[0].expression_id]
      expect { described_class.create_all!(user.id, expression_ids) }.to change(described_class, :count).by(2)
    end

    it 'create one bookmarking but not the one that already exists' do
      expression_ids = [bookmarking.expression_id, first_expression_items[0].expression_id]
      expect { described_class.create_all!(bookmarking.user_id, expression_ids) }.to change(described_class, :count).by(1)
    end
  end
end
