# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  before do
    10.times do
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
    end
  end

  it 'show a list of expressions' do
    visit '/'
    expect(all('li').count).to eq 21
  end

  describe 'titles and links' do
    context 'when two expressions were saved as one group' do
      it 'check the title and the link' do
        visit '/'
        expression_item = ExpressionItem.find_by(content: 'balcony')

        expect(first('li')).to have_link 'balcony and Veranda', href: expression_path(expression_item.expression)
      end
    end

    context 'when three expressions were saved as one group' do
      before do
        visit '/expressions/new'
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
        click_button '登録'
        visit '/'
      end

      it 'check the title and the link' do
        expression_item = ExpressionItem.find_by(content: 'word1')

        expect(all('li').last).to have_link 'word1, word2 and word3', href: expression_path(expression_item.expression)
      end
    end

    context 'when four expressions were saved as one group' do
      before do
        visit '/expressions/new'
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
        click_button '登録'
        visit '/'
      end

      it 'check the title and the link' do
        expression_item = ExpressionItem.find_by(content: 'word4')

        expect(all('li').last).to have_link 'word1, word2, word3 and word4', href: expression_path(expression_item.expression)
      end
    end

    context 'when five expressions were saved as one group' do
      before do
        visit '/expressions/new'
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
        click_button '登録'
        visit '/'
      end

      it 'check the title and the link' do
        expression_item = ExpressionItem.find_by(content: 'word5')

        expect(all('li').last).to have_link 'word1, word2, word3, word4 and word5', href: expression_path(expression_item.expression)
      end
    end
  end

  describe 'list order after editing note' do
    context 'when the note is before editing' do
      it 'check the list order by expression id 1' do
        visit '/'
        within first('li.expression') do
          expect(page).to have_link 'balcony and Veranda', href: expression_path(1)
        end
      end
    end

    context 'when the note is after editing' do
      before do
        visit '/'
        click_link 'balcony and Veranda'
        click_link '編集'
        3.times { click_button '次へ' }
        fill_in('メモ（任意）', with: 'note is added')
        click_button '編集する'
      end

      it 'check if the data is on the same place' do
        visit '/'
        within first('li.expression') do
          expect(page).to have_link 'balcony and Veranda', href: expression_path(1)
        end
      end
    end
  end
end
