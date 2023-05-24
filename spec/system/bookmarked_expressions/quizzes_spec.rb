# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BookmarkedExpressions Quiz' do
  context 'when user starts quiz from bookmark list' do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user1.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user1.id)) }
    let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user1.id)) }
    let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user1.id)) }

    before do
      user2 = FactoryBot.create(:user)
      fifth_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user2.id))

      FactoryBot.create(:bookmarking, user: user1, expression: first_expression_items[0].expression)
      FactoryBot.create(:bookmarking, user: user1, expression: second_expression_items[0].expression)
      FactoryBot.create(:bookmarking, user: user2, expression: fifth_expression_items[0].expression)
      FactoryBot.create(:memorising, user: user1, expression: third_expression_items[0].expression)

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user1.uid, info: { name: user1.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      has_text? 'ログインしました'

      visit bookmarked_expressions_quiz_path
    end

    it 'check the questions are from bookmarks' do
      expect(page).to have_css 'p.content-of-question'
      5.times do |n|
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(all('.move-to-bookmark-or-memorised-list li', visible: false).count).to eq 2
      find('summary', text: 'ブックマークする英単語・フレーズ').click
      expect(page).to have_field "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
      expect(page).to have_field "#{second_expression_items[0].content}, #{second_expression_items[1].content} and #{second_expression_items[2].content}"
      expect(page).not_to have_field "#{third_expression_items[0].content}, #{third_expression_items[1].content} and #{third_expression_items[2].content}"
      expect(page).not_to have_field "#{fourth_expression_items[0].content} and #{fourth_expression_items[1].content}"
    end

    it 'check the questions and answers are set correctly' do
      5.times do |n|
        if has_text?(first_expression_items[0].explanation)
          fill_in('解答を入力', with: first_expression_items[0].content)
          click_button 'クイズに解答する'
          expect(page).to have_content '◯ 正解!'
        elsif has_text?(first_expression_items[1].explanation)
          fill_in('解答を入力', with: first_expression_items[1].content)
          click_button 'クイズに解答する'
          expect(page).to have_content '◯ 正解!'
        elsif has_text?(second_expression_items[0].explanation)
          fill_in('解答を入力', with: second_expression_items[0].content)
          click_button 'クイズに解答する'
          expect(page).to have_content '◯ 正解!'
        else
          click_button 'クイズに解答する'
        end
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
    end
  end

  context 'when new user starts quiz from bookmarks' do
    let(:new_user) { FactoryBot.build(:user) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note)) }
    let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }

    before do
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id))

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      has_text? 'ログインしました'

      visit '/quiz'
      9.times do |n|
        click_button 'クイズに解答する'
        n < 8 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      find('summary', text: 'ブックマークする英単語・フレーズ').click
      find('label', text: 'balcony and Veranda').click
      click_button '保存する'
      has_text? 'ブックマークしました！'

      visit bookmarked_expressions_path
    end

    it 'check the questions are from bookmarks' do
      expect(page).to have_link 'クイズに挑戦'
      click_link 'クイズに挑戦'
      expect(page).to have_css 'p.content-of-question'
      7.times do |n|
        click_button 'クイズに解答する'
        n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      find('summary', text: 'ブックマークする英単語・フレーズ').click
      expect(all('.move-to-bookmark-or-memorised-list li').count).to eq 3
      expect(page).to have_field "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
      expect(page).to have_field "#{second_expression_items[0].content}, #{second_expression_items[1].content} and #{second_expression_items[2].content}"
      expect(page).to have_field "#{third_expression_items[0].content} and #{third_expression_items[1].content}"
    end
  end

  context 'when user does not have bookmarks' do
    let(:new_user) { FactoryBot.build(:user) }

    before do
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
      FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note))

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      has_text? 'ログインしました'
    end

    it 'check if the page is bookmarks list' do
      expect(new_user.bookmarkings.count).to eq 0
      expect(page).not_to have_link 'クイズに挑戦'
      visit bookmarked_expressions_quiz_path
      expect(page).to have_current_path bookmarked_expressions_path
      expect(page).to have_content 'このリストのクイズに問題が存在しません'
    end
  end

  context 'when user has not logged in' do
    it 'check if the page is bookmarks list' do
      visit bookmarked_expressions_path
      expect(page).not_to have_link 'クイズに挑戦'

      visit bookmarked_expressions_quiz_path
      expect(page).to have_current_path bookmarked_expressions_path
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end
  end
end
