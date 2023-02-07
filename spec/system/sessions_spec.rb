# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:user) { FactoryBot.create(:user) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })
  end

  describe 'log in' do
    it 'check the function of login' do
      visit '/'
      click_button 'Sign up/Log in with Google'
      expect(page).to have_content user.name
      expect(page).not_to have_button 'Sign up/Log in with Google'
    end

    it 'show a message when login succeed' do
      visit '/'
      click_button 'Sign up/Log in with Google'
      expect(page).to have_content 'Successfully logged in!'
    end
  end

  describe 'log out' do
    before do
      visit '/'
      click_button 'Sign up/Log in with Google'
    end

    it 'the logout button is invisible before click user name' do
      expect(page).not_to have_button 'Log out'
    end

    it 'the logout button is visible after click user name' do
      find('label', text: user.name).click
      expect(page).not_to have_css('div.invisible', visible: :hidden)
      expect(page).to have_button 'Log out'
    end

    it 'check the function of logout' do
      find('label', text: user.name).click
      click_button 'Log out'
      expect(page).to have_button 'Sign up/Log in with Google'
      expect(page).not_to have_content user.name
    end

    it 'show a message when logout succeed' do
      find('label', text: user.name).click
      click_button 'Log out'
      expect(page).to have_content 'Successfully logged out!'
    end
  end
end
