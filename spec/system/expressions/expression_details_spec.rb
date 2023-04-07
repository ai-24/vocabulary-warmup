# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  before do
    10.times do
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
    end
  end

  describe 'expressions/1' do
    it 'check url' do
      visit '/'
      click_link 'balcony and Veranda'
      expect(page).to have_content '下記の英単語・フレーズの違いについて'
      expect(page).to have_current_path expression_path(1), ignore_query: true
    end

    it 'show a title section' do
      visit '/'
      click_link 'balcony and Veranda'
      within '.title' do
        expect(page).to have_content '1. balcony'
        expect(page).to have_content '2. Veranda'
        expect(page).not_to have_content '4.'
      end
    end

    it 'show details of the first expression' do
      visit '/'
      click_link 'balcony and Veranda'
      within '.expression0' do
        expect(page).to have_content 'balcony'
        expect(page).to have_content 'A platform on the side of a building, accessible from inside the building.'
        expect(page).not_to have_content '例文'
      end
    end

    it 'show details of the second expression' do
      visit '/'
      click_link 'balcony and Veranda'
      within '.expression1' do
        expect(page).to have_content 'Veranda'
        expect(page).to have_content 'A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to si'
        expect(page).not_to have_content '例文'
      end
    end

    it 'not to show a note and a tag if there are no data' do
      visit '/expressions/1'
      expect(page).not_to have_content 'メモ'
      expect(page).not_to have_content 'タグ'
    end

    it 'check the expression list after clicking the back button that goes to root path' do
      visit '/expressions/1'
      click_link '英単語・フレーズ一覧に戻る'
      expect(all('li').count).to eq 21
      expect(first('li')).to have_link 'balcony and Veranda', href: expression_path(1)
    end
  end

  describe 'new expression with examples, a note and a tag' do
    before do
      visit '/expressions/new'
      fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
      fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
      fill_in('３つ目の英単語 / フレーズ', with: 'around the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
      fill_in('例文１', with: 'example of on the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of at the beach')
      fill_in('例文２', with: 'example of at the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of around the beach')
      click_button '次へ'
      fill_in('メモ（任意）', with: 'note')
      fill_in('タグ（任意）', with: 'preposition')
      find('input#tags').send_keys :return
      click_button '登録'
    end

    it 'show a title section' do
      visit '/'
      click_link 'on the beach, at the beach and around the beach'
      within '.title' do
        expect(page).to have_content '1. on the beach'
        expect(page).to have_content '2. at the beach'
        expect(page).to have_content '3. around the beach'
      end
    end

    it 'show details of the third expression' do
      visit '/'
      click_link 'on the beach, at the beach and around the beach'
      within '.expression2' do
        expect(page).to have_content 'around the beach'
        expect(page).to have_content 'explanation of around the beach'
      end
    end

    it 'check if examples of first expression are on the page' do
      visit '/'
      click_link 'on the beach, at the beach and around the beach'
      within '.expression0' do
        expect(page).to have_content '例文'
        expect(page).to have_content 'example of on the beach'
      end
    end

    it 'check if examples of second expression are on the page' do
      visit '/'
      click_link 'on the beach, at the beach and around the beach'
      within '.expression1' do
        expect(page).to have_content '例文'
        expect(page).to have_content 'example of at the beach'
      end
    end

    it 'check if a note is on the page' do
      visit '/'
      click_link 'on the beach, at the beach and around the beach'
      within '.note' do
        expect(page).to have_content 'メモ'
        expect(page).to have_content 'note'
      end
    end

    it 'check if a tag is on the page' do
      visit '/'
      click_link 'on the beach, at the beach and around the beach'
      within '.tag' do
        expect(page).to have_content 'タグ'
        expect(page).to have_content 'preposition'
      end
    end
  end

  describe 'delete expressions' do
    before do
      FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      visit '/'
      click_link 'balcony and Veranda'
    end

    it 'check if expression is deleted' do
      expect do
        click_button '削除'
        expect(page.accept_confirm).to eq 'この英単語又はフレーズを本当に削除しますか？'
        expect(page).to have_content '英単語又はフレーズを削除しました'
      end.to change(Expression, :count).by(-1).and change(ExpressionItem, :count).by(-2)

      visit '/'
      expect(page).not_to have_link 'balcony and Veranda'
    end

    it 'check if the expression is not deleted when cancel button is clicked' do
      expect do
        click_button '削除'
        expect(page.dismiss_confirm).to eq 'この英単語又はフレーズを本当に削除しますか？'
        within '.title' do
          expect(page).to have_content 'balcony'
        end
        click_link '英単語・フレーズ一覧に戻る'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0)

      expect(page).to have_link 'balcony and Veranda'
    end

    it 'check if the next expression is on the page after deleting expression' do
      delete_expression_item = ExpressionItem.find_by content: 'balcony'
      next_expression = delete_expression_item.expression.next
      accept_confirm do
        click_button '削除'
      end
      expect(page).to have_content '英単語又はフレーズを削除しました'

      next_expression.expression_items.each do |expression_item|
        within '.title' do
          expect(page).to have_content expression_item.content
        end
      end
    end
  end
end
