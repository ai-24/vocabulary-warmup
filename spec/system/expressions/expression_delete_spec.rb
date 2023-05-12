# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'delete first expression' do
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

    before do
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
      accept_confirm do
        click_button '削除'
      end
      expect(page).to have_content '英単語又はフレーズを削除しました'

      within '.title' do
        expect(page).to have_content "1. #{first_expression_items[0].content}"
        expect(page).to have_content "2. #{first_expression_items[1].content}"
      end
    end
  end

  describe 'delete another expression' do
    let!(:expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

    before do
      visit "/expressions/#{expression_items[0].expression.id}"
    end

    it 'check if the previous expression is on the page after deleting expression which is last id' do
      accept_confirm do
        click_button '削除'
      end
      expect(page).to have_content '英単語又はフレーズを削除しました'

      within '.title' do
        expect(page).to have_content '1. balcony'
        expect(page).to have_content '2. Veranda'
      end
    end
  end

  describe 'delete last expression in a list' do
    it 'check if root page is on the screen when the last expression is deleted' do
      visit '/'
      click_link 'balcony and Veranda'
      accept_confirm do
        click_button '削除'
      end
      has_text? '英単語又はフレーズを削除しました'

      expect(Expression.count).to eq 0
      expect(page).to have_current_path root_path, ignore_query: true
      expect(page).to have_content 'このリストに登録されている英単語またはフレーズはありません'
    end
  end
end
