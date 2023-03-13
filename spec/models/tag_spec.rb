# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  before do
    FactoryBot.create(:tag)
  end

  describe '.find_tags_object' do
    it 'return a new tag object when the tag does not exist on database' do
      new_tag_object = described_class.find_tags_object([described_class.new(name: 'test2')])

      expect(new_tag_object[0].id).to eq nil
      expect(new_tag_object[0].name).to eq 'test2'
      expect { new_tag_object[0].save }.to change(described_class, :count).by(1)
    end

    it 'return a tag object from database when the tag exist' do
      saved_tag_object = described_class.find_tags_object([described_class.new(name: 'test')])

      expect(saved_tag_object[0].id).not_to eq nil
      expect(saved_tag_object[0].name).to eq 'test'
      expect { saved_tag_object[0].save }.to change(described_class, :count).by(0)
    end
  end
end
