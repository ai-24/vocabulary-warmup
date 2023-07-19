# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'authority' do
    it 'check if expression is not deleted without login' do
      visit '/'
      click_link '試してみる(機能に制限あり)'
      expect(page).to have_current_path home_path
      click_link 'balcony and Veranda'
      within '.specific-expression' do
        expect(page).not_to have_button '削除'
      end
    end

    it 'check if the user who does not own expressions can not delete it' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user1.id))

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user2.uid, info: { name: user2.name } })

      visit '/'
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end

      expect(page).to have_content 'ログインしました'
      visit "/expressions/#{first_expression_items[0].expression.id}"
      expect(page).to have_current_path home_path
      expect(page).to have_content '権限がないため閲覧できません'
    end

    it 'check if expression which user_id is nil is not deleted' do
      user1 = FactoryBot.create(:user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user1.uid, info: { name: user1.name } })

      visit '/'
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end
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
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end
      has_text? 'ログインしました'

      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if expression is deleted' do
      expect do
        within '.specific-expression' do
          click_button '削除'
        end
        expect(page.accept_confirm).to eq 'この英単語又はフレーズを本当に削除しますか？'
        expect(page).to have_content '英単語又はフレーズを削除しました'
      end.to change(Expression, :count).by(-1).and change(ExpressionItem, :count).by(-2)

      visit '/'
      expect(page).not_to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
    end

    it 'check if the expression is not deleted when cancel button is clicked' do
      expect do
        within '.specific-expression' do
          click_button '削除'
        end
        expect(page.dismiss_confirm).to eq 'この英単語又はフレーズを本当に削除しますか？'
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
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end
      has_text? 'ログインしました'

      visit "/expressions/#{second_expression_items[0].expression.id}"
    end

    it 'check if the previous expression is on the page after deleting expression which is last id' do
      accept_confirm do
        within '.specific-expression' do
          click_button '削除'
        end
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

    it 'check if home page is on the screen when the last expression is deleted' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end
      expect(page).to have_content 'ログインしました'
      click_link 'balcony and Veranda'
      accept_confirm do
        within '.specific-expression' do
          click_button '削除'
        end
      end
      expect(page).to have_content '英単語又はフレーズを削除しました'

      expect(Expression.where('user_id = ?', user.id).count).to eq 0
      expect(page).to have_current_path home_path, ignore_query: true
      expect(page).to have_content 'このリストに登録されている英単語またはフレーズはありません'
    end
  end
end
