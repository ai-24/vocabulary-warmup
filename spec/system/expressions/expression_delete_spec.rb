# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'authority' do
    it 'check if expression is not deleted without login' do
      visit '/'
      within '.without-login' do
        click_link '試してみる'
      end
      expect(page).to have_current_path home_path
      click_link 'balcony and veranda'
      within '.specific-expression' do
        expect(page).not_to have_button '削除'
      end
    end

    it 'check if the user who does not own expressions can not delete it' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user1.id))

      sign_in_with_welcome_page '.last-login-button', user2
      expect(page).to have_content 'ログインしました'
      visit "/expressions/#{first_expression_items[0].expression.id}"
      expect(page).to have_current_path home_path
      expect(page).to have_content '権限がないため閲覧できません'
    end

    it 'check if expression which user_id is nil is not deleted' do
      user1 = FactoryBot.create(:user)

      sign_in_with_welcome_page '.last-login-button', user1
      expect(page).to have_content 'ログインしました'
      expect(Expression.where('user_id = ?', user1.id).count).to eq 0
      visit '/expressions/1'
      within '.specific-expression' do
        expect(page).not_to have_button '削除'
      end
    end
  end

  describe 'delete first expression' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:note, user_id: user.id)) }

    before do
      sign_in_with_welcome_page '.last-login-button', user
      has_text? 'ログインしました'

      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if expression is deleted' do
      expect do
        within '.specific-expression' do
          click_button '削除'
        end
        expect(page.accept_confirm).to eq 'この英単語・フレーズを本当に削除しますか？'
        expect(page).to have_content '英単語・フレーズを削除しました'
      end.to change(Expression, :count).by(-1).and change(ExpressionItem, :count).by(-2)

      visit '/'
      expect(page).not_to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if the expression is not deleted when cancel button is clicked' do
      expect do
        within '.specific-expression' do
          click_button '削除'
        end
        expect(page.dismiss_confirm).to eq 'この英単語・フレーズを本当に削除しますか？'
        within '.title' do
          expect(page).to have_content first_expression_items[0].content
        end
        click_link '一覧に戻る'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0)

      expect(page).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if the next expression is on the page after deleting expression' do
      accept_confirm do
        within '.specific-expression' do
          click_button '削除'
        end
      end
      expect(page).to have_content '英単語・フレーズを削除しました'

      within 'h1' do
        expect(page).to have_content second_expression_items[0].content
        expect(page).to have_content 'と'
        expect(page).to have_content second_expression_items[1].content
        expect(page).to have_content 'の違いについて'
      end
    end
  end

  describe 'delete another expression' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:note, user_id: user.id)) }

    before do
      sign_in_with_welcome_page '.last-login-button', user
      has_text? 'ログインしました'

      visit "/expressions/#{second_expression_items[0].expression.id}"
    end

    it 'check if the previous expression is on the page after deleting expression which is last id' do
      accept_confirm do
        within '.specific-expression' do
          click_button '削除'
        end
      end
      expect(page).to have_content '英単語・フレーズを削除しました'

      within 'h1' do
        expect(page).to have_content first_expression_items[0].content
        expect(page).to have_content 'と'
        expect(page).to have_content first_expression_items[1].content
        expect(page).to have_content 'の違いについて'
      end
    end
  end

  describe 'delete last expression in 未分類 list' do
    let(:user) { FactoryBot.build(:user) }

    it 'check if home page is on the screen when the last expression is deleted' do
      sign_in_with_welcome_page '.last-login-button', user
      expect(page).to have_content 'ログインしました'
      click_link 'balcony and veranda'
      accept_confirm do
        within '.specific-expression' do
          click_button '削除'
        end
      end
      expect(page).to have_content '英単語・フレーズを削除しました'

      expect(Expression.where('user_id = ?', user.id).count).to eq 0
      expect(page).to have_current_path home_path, ignore_query: true
      expect(page).to have_content 'このリストに登録している英単語・フレーズはありません'
    end
  end

  describe 'delete last expression in a 要復習 list' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    it 'check if the 要復習 list is on the screen when the last expression is deleted' do
      FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
      sign_in_with_welcome_page '.last-login-button', user
      expect(page).to have_content 'ログインしました'
      click_link '要復習'
      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
      accept_confirm do
        within '.specific-expression' do
          click_button '削除'
        end
      end
      expect(page).to have_content '英単語・フレーズを削除しました'
      expect(page).to have_current_path bookmarked_expressions_path
    end
  end

  describe 'delete last expression in 覚えた list' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    it 'check if the 覚えた list is on the screen when the last expression is deleted' do
      FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
      sign_in_with_welcome_page '.last-login-button', user
      expect(page).to have_content 'ログインしました'
      click_link '覚えた'
      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
      accept_confirm do
        within '.specific-expression' do
          click_button '削除'
        end
      end
      expect(page).to have_content '英単語・フレーズを削除しました'
      expect(page).to have_current_path memorised_expressions_path
    end
  end
end
