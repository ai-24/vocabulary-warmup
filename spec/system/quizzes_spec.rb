# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Quiz' do
  describe 'a quiz for everyone' do
    before do
      visit '/quiz'
    end

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
    describe 'quiz result that questions were two' do
      before do
        visit '/quiz'
      end

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

    describe 'quiz result that questions were six' do
      before do
        2.times { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
        visit '/quiz'
      end

      it 'check if the right number of user answers are on the page when 自分の解答を表示 is clicked' do
        5.times do
          fill_in('解答を入力', with: 'test')
          click_button 'クイズに解答する'
          click_button '次へ'
        end
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button 'クイズの結果を確認する'

        find('summary', text: '自分の解答を表示').click
        expect(all('ul.user-answer-list li').count).to eq 6
      end
    end

    describe 'lists that contain words and phrases that go to bookmark or memorised words list' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note)) }

      before do
        visit '/quiz'
        fill_in('解答を入力', with: 'balcony')
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: 'veranda')
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: first_expression_items[0].content)
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: 'wrong answer')
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: 'wrong answer')
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button 'クイズの結果を確認する'
      end

      it 'check if balcony and veranda is in the list that goes to memorised words list' do
        expect(page).not_to have_content 'balcony and Veranda'

        find('summary', text: '覚えたリストに移動する英単語・フレーズ').click
        expect(page).to have_content 'balcony and Veranda'
        expect(page).not_to have_content "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).not_to have_content(
          "#{second_expression_items[0].content}, #{second_expression_items[1].content} and #{second_expression_items[2].content}"
        )
        expect(all('ul.list-of-correct-answers li').count).to eq 1
      end

      it 'check if wrong answers are in the list that go to bookmark' do
        expect(all('ul.list-of-incorrect-answers li').count).to eq 0

        find('summary', text: 'ブックマークする英単語・フレーズ').click
        expect(page).to have_content "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).to have_content "#{second_expression_items[0].content}, #{second_expression_items[1].content} and #{second_expression_items[2].content}"
        expect(page).not_to have_content 'balcony and Veranda'
        expect(all('ul.list-of-incorrect-answers li').count).to eq 2
      end
    end
  end
end
