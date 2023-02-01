# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  let(:user) { FactoryBot.create(:user) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

    visit '/'
    click_button 'Sign up/Log in with Google'
  end

  it 'check the function of deleting user account' do
    find('label', text: user.name).click
    click_button 'Delete account'
    expect do
      expect(page.accept_confirm).to eq "アカウントを削除しますか？\n \n重要:アカウントを削除すると、このアプリに登録した全てのデータは削除されます。"
      expect(page).to have_content 'アカウントを削除しました'
    end.to change(User, :count).by(-1)
  end
end
