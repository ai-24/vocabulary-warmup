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
end
