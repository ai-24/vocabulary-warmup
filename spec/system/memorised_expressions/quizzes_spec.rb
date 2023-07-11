# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MemorisedExpressions Quiz' do
  context 'when user starts quiz from memorised list' do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:expression1) { FactoryBot.create(:empty_note, user_id: user1.id) }
    let!(:first_expression_item) { FactoryBot.create(:expression_item, expression: expression1) }
    let!(:second_expression_item) { FactoryBot.create(:expression_item2, expression: expression1) }

    let!(:expression2) { FactoryBot.create(:empty_note, user_id: user1.id) }
    let!(:third_expression_item) { FactoryBot.create(:expression_item3, expression: expression2) }
    let!(:fourth_expression_item) { FactoryBot.create(:expression_item4, expression: expression2) }
    let!(:fifth_expression_item) { FactoryBot.create(:expression_item5, expression: expression2) }

    before do
      third_expression_items = FactoryBot.create_list(:expression_item6, 3, expression: FactoryBot.create(:empty_note, user_id: user1.id))
      FactoryBot.create_list(:expression_item6, 2, expression: FactoryBot.create(:empty_note, user_id: user1.id))
      user2 = FactoryBot.create(:user)
      fifth_expression_items = FactoryBot.create_list(:expression_item6, 2, expression: FactoryBot.create(:empty_note, user_id: user2.id))

      FactoryBot.create(:memorising, user: user1, expression: first_expression_item.expression)
      FactoryBot.create(:memorising, user: user1, expression: third_expression_item.expression)
      FactoryBot.create(:memorising, user: user2, expression: fifth_expression_items[0].expression)
      FactoryBot.create(:bookmarking, user: user1, expression: third_expression_items[0].expression)

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user1.uid, info: { name: user1.name } })

      visit '/'
      within '.button-on-header' do
        click_button 'Sign up/Log in with Google'
      end
      has_text? 'ログインしました'

      click_link '覚えた語彙'
      click_link 'クイズに挑戦'
    end

    it 'check the questions are from memorised list' do
      expect(page).to have_css 'p.content-of-question'
      5.times do |n|
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(all('ul.user-answer-list li', visible: false).count).to eq 5
      find('summary', text: '自分の解答を表示').click
      expect(page).to have_content "Answer: #{first_expression_item.content}"
      expect(page).to have_content "Answer: #{second_expression_item.content}"
      expect(page).to have_content "Answer: #{third_expression_item.content}"
      expect(page).to have_content "Answer: #{fourth_expression_item.content}"
      expect(page).to have_content "Answer: #{fifth_expression_item.content}"
    end

    it 'check the questions and answers are set correctly' do
      5.times do |n|
        if has_text?(first_expression_item.explanation)
          fill_in('解答を入力', with: first_expression_item.content)
          click_button 'クイズに解答する'
          expect(page).to have_content '◯ 正解!'
        elsif has_text?(second_expression_item.explanation)
          fill_in('解答を入力', with: second_expression_item.content)
          click_button 'クイズに解答する'
          expect(page).to have_content '◯ 正解!'
        elsif has_text?(third_expression_item.explanation)
          fill_in('解答を入力', with: third_expression_item.content)
          click_button 'クイズに解答する'
          expect(page).to have_content '◯ 正解!'
        else
          click_button 'クイズに解答する'
        end
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
    end

    it 'check if a section of moving expressions to bookmark or memorised list is not on the result page when all answers were correct' do
      5.times do |n|
        if has_text?(first_expression_item.explanation)
          fill_in('解答を入力', with: first_expression_item.content)
        elsif has_text?(second_expression_item.explanation)
          fill_in('解答を入力', with: second_expression_item.content)
        elsif has_text?(third_expression_item.explanation)
          fill_in('解答を入力', with: third_expression_item.content)
        elsif has_text?(fourth_expression_item.explanation)
          fill_in('解答を入力', with: fourth_expression_item.content)
        elsif has_text?(fifth_expression_item.explanation)
          fill_in('解答を入力', with: fifth_expression_item.content)
        end
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(page).not_to have_selector('.section-of-correct-answers')
      expect(page).not_to have_selector('.section-of-wrong-answers')
      expect(page).not_to have_button '保存する'
    end

    it 'check if a message that recommends next action is not on the result page when a section of moving expressions is not there' do
      5.times do |n|
        if has_text?(first_expression_item.explanation)
          fill_in('解答を入力', with: first_expression_item.content)
        elsif has_text?(second_expression_item.explanation)
          fill_in('解答を入力', with: second_expression_item.content)
        elsif has_text?(third_expression_item.explanation)
          fill_in('解答を入力', with: third_expression_item.content)
        elsif has_text?(fourth_expression_item.explanation)
          fill_in('解答を入力', with: fourth_expression_item.content)
        elsif has_text?(fifth_expression_item.explanation)
          fill_in('解答を入力', with: fifth_expression_item.content)
        end
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(page).not_to have_content 'ブックマークや覚えた語彙リストに英単語・フレーズを保存した後は復習しましょう！'
      expect(page).not_to have_content '重要: 一度この画面を離れると戻れません。今回の結果をブックマークや覚えた語彙リストに保存する場合は、下記ボタンをクリックする前に必ず行なってください。'
    end

    it 'check if a section of moving expressions to bookmarks list is on the result page when answers are wrong' do
      5.times do |n|
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(page).not_to have_selector('.section-of-correct-answers')
      expect(page).to have_selector('.section-of-wrong-answers')
      expect(page).to have_button '保存する'
    end

    it 'check if request for saving memorising is not sent when bookmarking is saved' do
      5.times do |n|
        if has_text?(first_expression_item.explanation)
          fill_in('解答を入力', with: first_expression_item.content)
        elsif has_text?(second_expression_item.explanation)
          fill_in('解答を入力', with: second_expression_item.content)
        end
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(page).to have_selector('.section-of-wrong-answers')
      click_button '保存する'
      expect(page).to have_content 'ブックマークしました！'
      expect(page).not_to have_content '英単語・フレーズをブックマークしましたが覚えた語彙リストには保存できませんでした'
    end

    it 'check if memorising is destroyed when bookmarking is created' do
      5.times do |n|
        if has_text?(first_expression_item.explanation)
          fill_in('解答を入力', with: first_expression_item.content)
        elsif has_text?(second_expression_item.explanation)
          fill_in('解答を入力', with: second_expression_item.content)
        end
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(page).to have_selector('.section-of-wrong-answers')
      expect do
        click_button '保存する'
        expect(page).to have_content 'ブックマークしました！'
      end.to change(Bookmarking, :count).by(1).and change(Memorising, :count).by(-1)
    end

    it 'check if memorisings are destroyed when bookmarkings are created' do
      5.times do |n|
        click_button 'クイズに解答する'
        n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      expect(page).to have_selector('.section-of-wrong-answers')
      expect do
        click_button '保存する'
        expect(page).to have_content 'ブックマークしました！'
      end.to change(Bookmarking, :count).by(2).and change(Memorising, :count).by(-2)
    end
  end

  context 'when new user starts quiz from memorised list' do
    let(:new_user) { FactoryBot.build(:user) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:expression) { FactoryBot.create(:empty_note) }
    let!(:first_expression_item) { FactoryBot.create(:expression_item, expression:) }
    let!(:second_expression_item) { FactoryBot.create(:expression_item2, expression:) }

    before do
      FactoryBot.create_list(:expression_item3, 3, expression: FactoryBot.create(:empty_note))
      FactoryBot.create_list(:expression_item4, 2, expression: FactoryBot.create(:empty_note))
      FactoryBot.create_list(:expression_item5, 2, expression: FactoryBot.create(:empty_note, user_id: user.id))

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

      visit '/'
      within '.button-on-header' do
        click_button 'Sign up/Log in with Google'
      end
      has_text? 'ログインしました'

      click_link 'クイズに挑戦'
      9.times do |n|
        if has_text?('A platform on the side of a building, accessible from inside the building.')
          fill_in('解答を入力', with: 'balcony')
        elsif has_text?('A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.')
          fill_in('解答を入力', with: 'Veranda')
        elsif has_text?(first_expression_item.explanation)
          fill_in('解答を入力', with: first_expression_item.content)
        elsif has_text?(second_expression_item.explanation)
          fill_in('解答を入力', with: second_expression_item.content)
        end
        click_button 'クイズに解答する'
        n < 8 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      click_button '保存する'
      has_text? 'ブックマーク・覚えた語彙リストに保存しました！'

      visit memorised_expressions_path
    end

    it 'check the questions are from memorisied list' do
      expect(page).to have_link 'クイズに挑戦'
      click_link 'クイズに挑戦'
      expect(page).to have_css 'p.content-of-question'
      4.times do |n|
        click_button 'クイズに解答する'
        n < 3 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      find('summary', text: '自分の解答を表示').click
      expect(all('ul.user-answer-list li').count).to eq 4
      expect(page).to have_content 'Answer: balcony'
      expect(page).to have_content 'Answer: Veranda'
      expect(page).to have_content "Answer: #{first_expression_item.content}"
      expect(page).to have_content "Answer: #{second_expression_item.content}"
    end
  end

  context 'when user does not have memorised expressions' do
    let(:new_user) { FactoryBot.build(:user) }

    before do
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
      FactoryBot.create_list(:expression_item2, 3, expression: FactoryBot.create(:empty_note))

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

      visit '/'
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end
      has_text? 'ログインしました'
    end

    it 'check if the page is memorised list' do
      expect(new_user.memorisings.count).to eq 0
      click_link '覚えた語彙'
      expect(page).not_to have_link 'クイズに挑戦'
      visit memorised_expressions_quiz_path
      expect(page).to have_current_path memorised_expressions_path
      expect(page).to have_content 'このリストのクイズに問題が存在しません'
    end
  end

  context 'when user has not logged in' do
    it 'check if the page is memorised list' do
      visit '/'
      click_link '使ってみる'
      click_link '覚えた語彙'
      expect(page).not_to have_link 'クイズに挑戦'

      visit memorised_expressions_quiz_path
      expect(page).to have_current_path memorised_expressions_path
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end
  end
end
