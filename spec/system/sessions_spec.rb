# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:user) { FactoryBot.create(:user) }

  describe 'log in' do
    it 'check the function of login' do
      sign_in_with_welcome_page '.last-login-button', user
      expect(page).to have_content 'ログインしました'
      expect(page).to have_content user.name
      expect(page).not_to have_button 'Sign up/Log in with Google'
    end

    it 'check if current path is bookmarked_expressions after login' do
      sign_in_with_header '/bookmarked_expressions', user
      expect(page).to have_content 'ログインしました'
      expect(page).to have_current_path '/bookmarked_expressions'
    end

    it 'check if current path is memorised_expressions after login' do
      sign_in_with_header '/memorised_expressions', user
      expect(page).to have_content 'ログインしました'
      expect(page).to have_current_path '/memorised_expressions'
    end
  end

  describe 'log out' do
    before do
      sign_in_with_welcome_page '.last-login-button', user
    end

    it 'the logout button is invisible before click user name' do
      expect(page).to have_content 'ログインしました'
      expect(page).not_to have_button 'Log out'
    end

    it 'the logout button is visible after click user name' do
      expect(page).to have_content 'ログインしました'
      find('label', text: user.name).click
      expect(page).not_to have_css('div.invisible', visible: :hidden)
      expect(page).to have_button 'Log out'
    end

    it 'check the function of logout' do
      expect(page).to have_content 'ログインしました'
      find('label', text: user.name).click
      click_button 'Log out'
      expect(page).to have_button 'Sign up / Log in with Google'
      expect(page).not_to have_content user.name
    end

    it 'show a message when logout succeed' do
      expect(page).to have_content 'ログインしました'
      find('label', text: user.name).click
      click_button 'Log out'
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
