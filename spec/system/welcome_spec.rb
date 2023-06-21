# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome' do
  let(:user) { FactoryBot.build(:user) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

    visit '/welcome'
  end

  it 'check sign up button' do
    within '.welcome' do
      click_button 'Sign up/Log in with Google'
    end
    expect(page).to have_content 'ログインしました'
    expect(page).to have_current_path root_path
  end

  it 'check 使ってみる link' do
    click_link '使ってみる'
    expect(page).to have_current_path root_path
  end
end
