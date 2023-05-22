# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'delete accounts' do
    context 'when user is new' do
      let(:user) { FactoryBot.build(:user) }

      before do
        15.times do
          FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
        end
        FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note))

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
      end

      it 'check the function of deleting user account' do
        find('label', text: user.name).click
        click_button 'Delete account'
        expect do
          expect(page.accept_confirm).to eq "アカウントを削除しますか？\n \n重要:アカウントを削除すると、このアプリに登録した全てのデータは削除されます。"
          expect(page).to have_content 'アカウントを削除しました'
        end.to change(User, :count).by(-1).and change(Expression, :count).by(-17).and change(ExpressionItem, :count).by(-35).and change(Example, :count).by(-2)
      end
    end

    context 'when user is the one who has bookmarks and memorised words list' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        expressions = []
        10.times do
          expressions.push(FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)))
          expressions.push(FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)))
        end

        8.times do |n|
          FactoryBot.create(:memorising, user:, expression: expressions[n][0].expression)
        end

        7.times do |n|
          FactoryBot.create(:bookmarking, user:, expression: expressions[n + 8][0].expression)
        end

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
      end

      it 'check if user is deleted' do
        find('label', text: user.name).click
        click_button 'Delete account'
        expect do
          expect(page.accept_confirm).to eq "アカウントを削除しますか？\n \n重要:アカウントを削除すると、このアプリに登録した全てのデータは削除されます。"
          expect(page).to have_content 'アカウントを削除しました'
        end.to change(User, :count).by(-1).and change(Expression, :count).by(-20).and change(
          ExpressionItem, :count
        ).by(-50).and change(Example, :count).by(0).and change(Bookmarking, :count).by(-7).and change(Memorising, :count).by(-8)
      end
    end

    context 'when user is the one who has tags' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        expressions = []
        10.times do
          expressions.push(FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)))
          expressions.push(FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)))
        end

        3.times do
          FactoryBot.create(:example, expression_item: expressions[0][0])
          FactoryBot.create(:example, expression_item: expressions[1][0])
          FactoryBot.create(:example, expression_item: expressions[1][1])
        end

        tag1 = FactoryBot.create(:tag)
        tag2 = FactoryBot.create(:tag, name: '2023')

        5.times do |n|
          FactoryBot.create(:tagging, tag: tag1, expression: expressions[n][0].expression)
          FactoryBot.create(:tagging, tag: tag2, expression: expressions[n][0].expression)
        end

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
      end

      it 'check if user is deleted' do
        find('label', text: user.name).click
        click_button 'Delete account'
        expect do
          expect(page.accept_confirm).to eq "アカウントを削除しますか？\n \n重要:アカウントを削除すると、このアプリに登録した全てのデータは削除されます。"
          expect(page).to have_content 'アカウントを削除しました'
        end.to change(User, :count).by(-1).and change(Expression, :count).by(-20).and change(
          ExpressionItem, :count
        ).by(-50).and change(Example, :count).by(-9).and change(Tag, :count).by(0).and change(Tagging, :count).by(-10)
      end
    end

    context 'when user is the one who has tags, bookmarks and memorised words list' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        expressions = []
        30.times do
          expressions.push(FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)))
          expressions.push(FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)))
        end

        2.times do
          FactoryBot.create(:example, expression_item: expressions[0][0])
          FactoryBot.create(:example, expression_item: expressions[1][0])
          FactoryBot.create(:example, expression_item: expressions[1][1])
          FactoryBot.create(:example, expression_item: expressions[2][1])
          FactoryBot.create(:example, expression_item: expressions[3][1])
        end

        tag1 = FactoryBot.create(:tag)
        tag2 = FactoryBot.create(:tag, name: '留学')

        16.times do |n|
          FactoryBot.create(:tagging, tag: tag1, expression: expressions[n][0].expression)
          FactoryBot.create(:tagging, tag: tag2, expression: expressions[n][0].expression)
        end

        20.times do |n|
          FactoryBot.create(:memorising, user:, expression: expressions[n][0].expression)
        end

        6.times do |n|
          FactoryBot.create(:bookmarking, user:, expression: expressions[n + 20][0].expression)
        end

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
      end

      it 'check if user is deleted' do
        find('label', text: user.name).click
        click_button 'Delete account'
        expect do
          expect(page.accept_confirm).to eq "アカウントを削除しますか？\n \n重要:アカウントを削除すると、このアプリに登録した全てのデータは削除されます。"
          expect(page).to have_content 'アカウントを削除しました'
        end.to change(User, :count).by(-1).and change(Expression, :count).by(-60).and change(
          ExpressionItem, :count
        ).by(-150).and change(Example, :count).by(-10).and change(Tag, :count).by(0).and change(
          Tagging, :count
        ).by(-32).and change(Bookmarking, :count).by(-6).and change(Memorising, :count).by(-20)
      end
    end
  end
end
