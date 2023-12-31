# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome' do
  let(:user) { FactoryBot.build(:user) }

  it 'check sign up button' do
    sign_in_with_welcome_page '.last-login-button', user
    expect(page).to have_content 'ログインしました'
    expect(page).to have_current_path home_path
  end

  it 'check 試してみる link' do
    visit '/'
    within '.without-login' do
      click_link '試してみる'
    end
    expect(page).to have_current_path home_path

    visit '/'
    within '.recommended-users' do
      click_link '試してみる'
    end
    expect(page).to have_current_path home_path
  end

  it 'check the button of 利用規約 on footer' do
    visit '/'
    expect(page).to have_link '利用規約'
    click_link '利用規約'
    expect(page).to have_current_path terms_of_service_path
  end

  it 'check the button of プライバシーポリシー on footer' do
    visit '/'
    expect(page).to have_link 'プライバシーポリシー'
    click_link 'プライバシーポリシー'
    expect(page).to have_content 'お客様の情報を利用する目的'
    expect(page).to have_current_path privacy_policy_path
  end
end
