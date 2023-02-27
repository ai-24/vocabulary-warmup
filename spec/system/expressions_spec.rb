# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  before do
    visit '/expressions/new'
  end

  describe 'create expressions' do
    context 'when two phrases, the explanations, one example for each and the note are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
        fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
        fill_in('例文１', with: 'example of on the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of at the beach')
        fill_in('例文２', with: 'example of at the beach')
        click_button '次へ'
        fill_in('メモ（任意）', with: 'note')
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content 'Expression was successfully created.'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(2).and change(Example, :count).by(2)
      end
    end

    context 'when three words, the explanations, one example for one word without the note are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        fill_in('例文１', with: 'example of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content 'Expression was successfully created.'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(3).and change(Example, :count).by(1)
      end
    end

    context 'when four words, the explanations, two examples for each without the note are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        fill_in('例文１', with: 'first example of word1')
        fill_in('例文２', with: 'second example of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        fill_in('例文１', with: 'first example of word2')
        fill_in('例文２', with: 'second example of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        fill_in('例文１', with: 'first example of word3')
        fill_in('例文２', with: 'second example of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        fill_in('例文１', with: 'first example of word4')
        fill_in('例文２', with: 'second example of word4')
        click_button '次へ'
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content 'Expression was successfully created.'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(4).and change(Example, :count).by(8)
      end
    end

    context 'when five words, the explanations, three example for two words without the note are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        fill_in('５つ目の英単語 / フレーズ', with: 'word5')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        fill_in('例文１', with: 'first example of word4')
        fill_in('例文２', with: 'second example of word4')
        fill_in('例文３', with: 'third example of word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word5')
        fill_in('例文１', with: 'first example of word5')
        fill_in('例文２', with: 'second example of word5')
        fill_in('例文３', with: 'third example of word5')
        click_button '次へ'
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content 'Expression was successfully created.'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(5).and change(Example, :count).by(6)
      end
    end
  end

  describe 'validation error' do
    describe 'words and phrases' do
      it 'show validation error if only one word is given' do
        fill_in('１つ目の英単語 / フレーズ', with: 'word')
        click_button '次へ'
        expect(page).to have_css '.text-red-600'
        expect(page).to have_content '英単語又はフレーズを２つ以上入力してください'
        expect(page).not_to have_content '{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。'
      end

      it 'show validation error if no words are given' do
        expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
        click_button '次へ'
        expect(page).to have_content '英単語又はフレーズを２つ以上入力してください'
        expect(page).not_to have_content '{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。'
      end
    end

    describe 'explanations' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
        fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
        click_button '次へ'
      end

      it 'show validation error if the explanation is not given' do
        expect(page).to have_content '{word}について'
        expect(page).not_to have_css '.text-red-600'
        click_button '次へ'
        expect(page).to have_css '.text-red-600'
      end
    end

    describe 'examples' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
      end

      it 'no validation error when examples are not given' do
        expect(page).to have_content '{word}について'
        expect(page).not_to have_css '.text-red-600'
      end
    end

    describe 'applicable scope' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
        fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
        click_button '次へ'
      end

      it 'check if previous page does not have validation error after clicking a back button on the page that has validation error' do
        expect(page).not_to have_css '.text-red-600'
        click_button '次へ'
        expect(page).to have_css '.text-red-600'
        click_button '戻る'
        expect(page).not_to have_css '.text-red-600'
      end
    end
  end

  describe 'the back button on the last page' do
    context 'when two expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
      end
    end

    context 'when three expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
      end
    end

    context 'when four expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
      end
    end

    context 'when five expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        fill_in('５つ目の英単語 / フレーズ', with: 'word5')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word5')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word5')
      end
    end
  end
end
