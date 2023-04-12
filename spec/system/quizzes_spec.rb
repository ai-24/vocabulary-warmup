# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Quiz' do
  before do
    visit '/quiz'
  end

  describe 'a quiz for everyone' do
    it 'check if one question and no answer is on the question screen' do
      expect(page).to have_content 'A platform on the side of a building, accessible from inside the building.'
      expect(page).not_to have_content 'A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy'
      expect(page).not_to have_content 'balcony'
    end

    it 'check if the correct answer is judged as right one' do
      fill_in('解答を入力', with: 'balcony')
      click_button 'クイズに解答する'
      expect(page).to have_content '◯ 正解!'
    end

    it 'check if the incorrect answer is judged as wrong one' do
      fill_in('解答を入力', with: 'terrace')
      click_button 'クイズに解答する'
      expect(page).not_to have_content '◯ 正解!'
      expect(page).to have_content '×不正解'
      expect(page).to have_content '正解は{answer}です' # answerの値が取れているかはVue側でテストする
    end

    it 'check the feedback message if answer is not given by a user' do
      click_button 'クイズに解答する'
      expect(page).not_to have_content '◯ 正解!'
      expect(page).not_to have_content '×不正解'
      expect(page).to have_content '×正解は{answer}です'
    end

    it 'check the button and message on the last screen' do
      fill_in('解答を入力', with: 'balcony')
      click_button 'クイズに解答する'
      click_button '次へ'
      fill_in('解答を入力', with: 'veranda')
      click_button 'クイズに解答する'
      expect(page).to have_content '問題が全て出題されました'
      expect(page).to have_button 'クイズの結果を確認する'
      expect(page).not_to have_button '次へ'
    end
  end

  describe 'quiz result' do
    it 'change the screen from quiz to result' do
      fill_in('解答を入力', with: 'balcony')
      click_button 'クイズに解答する'
      click_button '次へ'
      fill_in('解答を入力', with: 'veranda')
      click_button 'クイズに解答する'
      click_button 'クイズの結果を確認する'

      expect(page).not_to have_content '問題'
      expect(page).to have_content 'クイズお疲れ様でした！'
    end

    it 'show user answers list' do
      fill_in('解答を入力', with: 'Balcony')
      click_button 'クイズに解答する'
      click_button '次へ'
      fill_in('解答を入力', with: 'wrong answer')
      click_button 'クイズに解答する'
      click_button 'クイズの結果を確認する'

      find('summary', text: '自分の解答を表示').click
      expect(page).to have_content '◯ Balcony'
      expect(page).to have_content '× wrong answer'
    end

    it 'show 未入力 if the user answer is blank' do
      fill_in('解答を入力', with: '')
      click_button 'クイズに解答する'
      click_button '次へ'
      fill_in('解答を入力', with: 'veranda')
      click_button 'クイズに解答する'
      click_button 'クイズの結果を確認する'

      find('summary', text: '自分の解答を表示').click
      expect(page).to have_content '× 未入力'
    end

    it 'show important notice with red text color' do
      fill_in('解答を入力', with: '')
      click_button 'クイズに解答する'
      click_button '次へ'
      fill_in('解答を入力', with: 'veranda')
      click_button 'クイズに解答する'
      click_button 'クイズの結果を確認する'

      expect(page).to have_selector(
        '.text-red-600',
        text: '重要: 一度この画面を離れると戻れません。今回の結果をブックマークや覚えたリストに移動させる場合は、下記ボタンをクリックする前に必ず行なってください。'
      )
    end

    it 'show new quiz' do
      fill_in('解答を入力', with: '')
      click_button 'クイズに解答する'
      click_button '次へ'
      fill_in('解答を入力', with: 'veranda')
      click_button 'クイズに解答する'
      click_button 'クイズの結果を確認する'

      click_button 'クイズに再挑戦'
      expect(page).not_to have_content '{totalQuestions}問中{numberOfCorrectAnswers}問正解です'
      expect(page).to have_content '問題'
    end
  end
end
