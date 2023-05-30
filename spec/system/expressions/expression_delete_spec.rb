# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'authority' do
    it 'check if expression is not deleted without login' do
      visit '/'
      click_link 'balcony and Veranda'
      expect(page).not_to have_button '削除'
    end

    it 'check if the user who does not own expressions can not delete it' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user1.id))

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user2.uid, info: { name: user2.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      expect(page).to have_content 'ログインしました'
      visit "/expressions/#{first_expression_items[0].expression.id}"
      expect(page).to have_current_path root_path
      expect(page).to have_content '権限がないため閲覧できません'
    end

    it 'check if expression which user_id is nil is not deleted' do
      user1 = FactoryBot.create(:user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user1.uid, info: { name: user1.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      expect(page).to have_content 'ログインしました'
      expect(Expression.where('user_id = ?', user1.id).count).to eq 0
      visit '/expressions/1'
      expect(page).not_to have_button '削除'
    end
  end

  describe 'delete first expression' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:note, user_id: user.id)) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      has_text? 'ログインしました'

      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if expression is deleted' do
      expect do
        click_button '削除'
        expect(page.accept_confirm).to eq 'この英単語又はフレーズを本当に削除しますか？'
        expect(page).to have_content '英単語又はフレーズを削除しました'
      end.to change(Expression, :count).by(-1).and change(ExpressionItem, :count).by(-2)

      visit '/'
      expect(page).not_to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if the expression is not deleted when cancel button is clicked' do
      expect do
        click_button '削除'
        expect(page.dismiss_confirm).to eq 'この英単語又はフレーズを本当に削除しますか？'
        within '.title' do
          expect(page).to have_content first_expression_items[0].content
        end
        click_link '英単語・フレーズ一覧に戻る'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0)

      expect(page).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if the next expression is on the page after deleting expression' do
      accept_confirm do
        click_button '削除'
      end
      expect(page).to have_content '英単語又はフレーズを削除しました'

      within '.title' do
        expect(page).to have_content "1. #{second_expression_items[0].content}"
        expect(page).to have_content "2. #{second_expression_items[1].content}"
      end
    end
  end

  describe 'delete another expression' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:note, user_id: user.id)) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      has_text? 'ログインしました'

      visit "/expressions/#{second_expression_items[0].expression.id}"
    end

    it 'check if the previous expression is on the page after deleting expression which is last id' do
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

  describe 'delete last expression in a list' do
    let(:user) { FactoryBot.build(:user) }

    it 'check if root page is on the screen when the last expression is deleted' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      expect(page).to have_content 'ログインしました'
      click_link 'balcony and Veranda'
      accept_confirm do
        click_button '削除'
      end
      has_text? '英単語又はフレーズを削除しました'

      expect(Expression.where('user_id = ?', user.id).count).to eq 0
      expect(page).to have_current_path root_path, ignore_query: true
      expect(page).to have_content 'このリストに登録されている英単語またはフレーズはありません'
    end
  end
end
