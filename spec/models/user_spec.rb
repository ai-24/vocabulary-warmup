# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe '.find_or_create_from_auth_hash!' do
    it 'find the user who already exist' do
      auth_hash = { uid: user.uid, info: { name: user.name } }
      expect { described_class.find_or_create_from_auth_hash!(auth_hash) }.not_to change(described_class, :count)
    end

    it 'create a new user' do
      auth_hash = { uid: Faker::Omniauth.google[:uid], info: { name: Faker::Name.name } }
      expect { described_class.find_or_create_from_auth_hash!(auth_hash) }.to change(described_class, :count).by(1)
    end
  end
end
