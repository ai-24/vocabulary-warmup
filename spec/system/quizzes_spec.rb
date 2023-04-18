# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Quiz' do
  describe 'a quiz for everyone' do
    before do
      visit '/quiz'
    end

    it 'check if one question and no answer is on the question screen' do
      if has_text?('A platform on the side of a building, accessible from inside the building.')
        expect(page).to have_content 'A platform on the side of a building, accessible from inside the building.'
        expect(page).not_to have_content 'A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy'
        expect(page).not_to have_content 'balcony'
      else
        expect(page).to have_content(
          'A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.'
        )
        expect(page).not_to have_content 'A platform on the side of a building, accessible from inside the building.'
        expect(page).not_to have_content 'Veranda'
      end
    end

    it 'check if the correct answer is judged as right one' do
      if has_text?('A platform on the side of a building, accessible from inside the building.')
        fill_in('解答を入力', with: 'balcony')
      else
        fill_in('解答を入力', with: 'Veranda')
      end
      click_button 'クイズに解答する'
      expect(page).to have_content '◯ 正解!'
      expect(page).not_to have_content '×不正解'
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
    describe 'check if screens change' do
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

    describe 'show user answers when one answer is correct and one answer is incorrect' do
      let(:answers) { [] } # クイズの問題がランダムに出題されるため、クイズで入力した値をexampleで取得できるようにbeforeでこの配列に値を代入

      before do
        visit '/quiz'
        fill_in('解答を入力', with: 'wrong answer')
        click_button 'クイズに解答する'
        click_button '次へ'
        if has_text?('A platform on the side of a building, accessible from inside the building.')
          fill_in('解答を入力', with: 'Balcony')
          answers.push 'Balcony'
        else
          fill_in('解答を入力', with: 'veranda')
          answers.push 'veranda'
        end
        click_button 'クイズに解答する'
        click_button 'クイズの結果を確認する'
      end

      it 'check user answers list' do
        find('summary', text: '自分の解答を表示').click

        expect(page).to have_content '× wrong answer'
        expect(page).to have_content('◯ Balcony') if answers[0] == 'Balcony'
        expect(page).to have_content('◯ veranda') if answers[0] == 'veranda'
      end
    end

    describe 'show user answers when an answer was not given' do
      before do
        visit '/quiz'
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: 'veranda')
        click_button 'クイズに解答する'
        click_button 'クイズの結果を確認する'
      end

      it 'show 未入力 if the user answer is blank' do
        find('summary', text: '自分の解答を表示').click
        expect(page).to have_content '× 未入力'
      end
    end

    describe 'show important notice' do
      before do
        visit '/quiz'
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button '次へ'
        fill_in('解答を入力', with: 'veranda')
        click_button 'クイズに解答する'
        click_button 'クイズの結果を確認する'
      end

      it 'show important notice with red text color' do
        expect(page).to have_selector(
          '.text-red-600',
          text: '重要: 一度この画面を離れると戻れません。今回の結果をブックマークや覚えたリストに移動させる場合は、下記ボタンをクリックする前に必ず行なってください。'
        )
      end
    end

    describe 'show user answers when questions were six' do
      before do
        2.times { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }

        visit '/quiz'
        5.times do
          fill_in('解答を入力', with: 'test')
          click_button 'クイズに解答する'
          click_button '次へ'
        end
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button 'クイズの結果を確認する'
      end

      it 'check if the right number of user answers are on the page when 自分の解答を表示 is clicked' do
        find('summary', text: '自分の解答を表示').click
        expect(all('ul.user-answer-list li').count).to eq 6
      end
    end

    context 'when one expression is in the list that go to bookmark and one expression is in the list that go to memorised words list' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
      let(:answers) { [] } # クイズの問題がランダムに出題されるため、クイズで入力した値をexampleで取得できるようにbeforeでこの配列に値を代入

      before do
        visit '/quiz'
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button '次へ'
        3.times do |n|
          if has_text?('A platform on the side of a building, accessible from inside the building.')
            fill_in('解答を入力', with: 'balcony')
            answers.push('balcony')
          elsif has_text?('A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.')
            fill_in('解答を入力', with: 'veranda')
            answers.push('veranda')
          elsif has_text?(first_expression_items[0].explanation)
            fill_in('解答を入力', with: first_expression_items[0].content)
          elsif has_text?(first_expression_items[1].explanation)
            fill_in('解答を入力', with: first_expression_items[1].content)
          end

          click_button 'クイズに解答する'
          n < 2 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
      end

      it 'check if one expression is in the list that goes to memorised words list' do
        expect(all('ul.list-of-correct-answers li').count).to eq 0

        find('summary', text: '覚えたリストに移動する英単語・フレーズ').click
        if answers.count == 2
          expect(page).to have_content 'balcony and Veranda'
          expect(page).not_to have_content "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        else
          expect(page).to have_content "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
          expect(page).not_to have_content 'balcony and Veranda'
        end

        expect(all('ul.list-of-correct-answers li').count).to eq 1
      end

      it 'check if one expression is in the list that go to bookmark' do
        expect(all('ul.list-of-incorrect-answers li').count).to eq 0

        find('summary', text: 'ブックマークする英単語・フレーズ').click
        if answers.count == 2
          expect(page).to have_content "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
          expect(page).not_to have_content 'balcony and Veranda'
        else
          expect(page).to have_content 'balcony and Veranda'
          expect(page).not_to have_content "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        end

        expect(all('ul.list-of-incorrect-answers li').count).to eq 1
      end
    end

    context 'when two expressions are in memorised words list and zero expression is in bookmark list' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note)) }

      before do
        visit '/quiz'
        5.times do |n|
          if has_text?('A platform on the side of a building, accessible from inside the building.')
            fill_in('解答を入力', with: 'balcony')
          elsif has_text?('A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.')
            fill_in('解答を入力', with: 'veranda')
          elsif has_text?(first_expression_items[0].explanation)
            fill_in('解答を入力', with: first_expression_items[0].content)
          elsif has_text?(first_expression_items[1].explanation)
            fill_in('解答を入力', with: first_expression_items[1].content)
          elsif has_text?(first_expression_items[2].explanation)
            fill_in('解答を入力', with: first_expression_items[2].content)
          end
          click_button 'クイズに解答する'
          n < 4 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
      end

      it 'check if memorised words list has two expressions' do
        expect(all('ul.list-of-correct-answers li').count).to eq 0

        find('summary', text: '覚えたリストに移動する英単語・フレーズ').click

        expect(first('ul.list-of-correct-answers li')).to have_content 'balcony and Veranda'
        expect(all('ul.list-of-correct-answers li')[1]).to have_content(
          "#{first_expression_items[0].content}, #{first_expression_items[1].content} and #{first_expression_items[2].content}"
        )

        find('summary', text: 'ブックマークする英単語・フレーズ').click
        expect(all('ul.list-of-incorrect-answers li').count).to eq 0
      end
    end

    context 'when two expressions are in bookmark list and zero expression is in memorised words list' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note)) }

      before do
        visit '/quiz'
        2.times do
          fill_in('解答を入力', with: 'wrong answer')
          click_button 'クイズに解答する'
          click_button '次へ'
          fill_in('解答を入力', with: '')
          click_button 'クイズに解答する'
          click_button('次へ')
        end
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        click_button('クイズの結果を確認する')
      end

      it 'check if bookmark list has two expressions' do
        expect(all('ul.list-of-incorrect-answers li').count).to eq 0

        find('summary', text: 'ブックマークする英単語・フレーズ').click
        expect(first('ul.list-of-incorrect-answers li')).to have_content 'balcony and Veranda'
        expect(all('ul.list-of-incorrect-answers li')[1]).to have_content(
          "#{first_expression_items[0].content}, #{first_expression_items[1].content} and #{first_expression_items[2].content}"
        )

        find('summary', text: '覚えたリストに移動する英単語・フレーズ').click
        expect(all('ul.list-of-correct-answers li').count).to eq 0
      end
    end
  end
end
