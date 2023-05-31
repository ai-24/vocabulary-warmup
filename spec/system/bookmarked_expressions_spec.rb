# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarked expressions' do
  context 'when user logged in' do
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:third_expression_items) { FactoryBot.create_list(:expression_item3, 3, expression: FactoryBot.create(:empty_note)) }
    let(:user) { FactoryBot.build(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
    end

    context 'when there are no bookmarks' do
      it 'show a message that there are no bookmarks' do
        expect(page).to have_content 'ログインしました'
        visit '/bookmarked_expressions'
        expect(page).to have_content user.name
        expect(all('li.expression').count).to eq 0
        expect(page).to have_content 'ブックマークしている英単語またはフレーズはありません'
      end

      it 'check tabs' do
        expect(page).to have_content 'ログインしました'
        visit '/bookmarked_expressions'

        within '.page_tabs' do
          expect(page).to have_link '英単語・フレーズ', href: root_path
          expect(page).to have_link 'ブックマーク', href: bookmarked_expressions_path
          expect(page).to have_link '覚えた英単語・フレーズ', href: memorised_expressions_path
          click_link '英単語・フレーズ'
        end
        expect(page).to have_current_path root_path
        expect(all('li.expression').count).to eq 4
        within '.page_tabs' do
          click_link 'ブックマーク'
          click_link '覚えた英単語・フレーズ'
        end
        expect(page).to have_current_path memorised_expressions_path
        expect(page).to have_content 'このリストに登録している英単語またはフレーズはありません'
      end
    end

    context 'when there are bookmarks' do
      before do
        has_text? 'ログインしました'
        visit '/quiz'

        9.times do |n|
          fill_in('解答を入力', with: '')
          click_button 'クイズに解答する'
          n < 8 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end

        find('summary', text: 'ブックマークする英単語・フレーズ').click
        find('label', text: 'balcony and Veranda').click
        click_button '保存する'
        has_text? 'ブックマークしました！'

        visit '/bookmarked_expressions'
      end

      it 'show a list of bookmarked expressions' do
        expect(all('li').count).to eq 3
        expect(page).not_to have_content 'ブックマークしている英単語またはフレーズはありません'
        expect(page).not_to have_content 'ログインしていないため閲覧できません'
      end

      it 'check titles and links' do
        expression_item_of_first_expression = ExpressionItem.where(content: first_expression_items[0].content).last
        expression_item_of_second_expression = ExpressionItem.where(content: second_expression_items[0].content).last
        expression_item_of_third_expression = ExpressionItem.where(content: third_expression_items[0].content).last

        expect(first('li.expression')).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}",
                                                    href: expression_path(expression_item_of_first_expression.expression)
        expect(all('li.expression')[1]).to have_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}",
                                                     href: expression_path(expression_item_of_second_expression.expression)
        expect(all('li.expression')[2]).to have_link(
          "#{third_expression_items[0].content}, #{third_expression_items[1].content} and #{third_expression_items[2].content}",
          href: expression_path(expression_item_of_third_expression.expression)
        )
        expect(page).not_to have_link 'balcony and Veranda'
      end

      it 'check tabs' do
        within '.page_tabs' do
          expect(page).to have_link '英単語・フレーズ', href: root_path
          expect(page).to have_link 'ブックマーク', href: bookmarked_expressions_path
          expect(page).to have_link '覚えた英単語・フレーズ', href: memorised_expressions_path
        end
      end
    end

    context 'when bookmarks were made by two different times' do
      before do
        has_text? 'ログインしました'
        visit '/quiz'

        9.times do |n|
          click_button 'クイズに解答する'
          n < 8 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        find('summary', text: 'ブックマークする英単語・フレーズ').click
        find('label', text: 'balcony and Veranda').click
        click_button '保存する'
        has_text? 'ブックマークしました！'

        visit '/quiz'
        2.times do |n|
          click_button 'クイズに解答する'
          n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        has_text? 'ブックマークしました！'

        visit '/bookmarked_expressions'
      end

      it 'check order' do
        expression_item_of_first_expression = ExpressionItem.where(content: first_expression_items[0].content).last
        expression_item_of_second_expression = ExpressionItem.where(content: second_expression_items[0].content).last
        expression_item_of_third_expression = ExpressionItem.where(content: third_expression_items[0].content).last
        balcony = ExpressionItem.where(content: 'balcony').last
        expect(first('li.expression')).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}",
                                                    href: expression_path(expression_item_of_first_expression.expression)
        expect(all('li.expression')[1]).to have_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}",
                                                     href: expression_path(expression_item_of_second_expression.expression)
        expect(all('li.expression')[2]).to have_link(
          "#{third_expression_items[0].content}, #{third_expression_items[1].content} and #{third_expression_items[2].content}",
          href: expression_path(expression_item_of_third_expression.expression)
        )
        expect(all('li.expression').last).to have_link 'balcony and Veranda', href: expression_path(balcony.expression)
      end
    end
  end

  context 'when user is not logged in' do
    let(:user) { FactoryBot.build(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      has_text? 'ログインしました'

      visit '/quiz'

      2.times do |n|
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      click_button '保存する'

      find('label', text: user.name).click
      click_button 'Log out'
    end

    it 'show message that is not logged in' do
      expect(page).to have_content 'ログアウトしました'

      visit '/bookmarked_expressions'
      expect(page).to have_button 'Sign up/Log in with Google'
      expect(all('li.expression').count).to eq 0
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end

    it 'check tabs' do
      expect(page).to have_content 'ログアウトしました'
      visit '/bookmarked_expressions'

      within '.page_tabs' do
        expect(page).to have_link '英単語・フレーズ', href: root_path
        expect(page).to have_link 'ブックマーク', href: bookmarked_expressions_path
        expect(page).to have_link '覚えた英単語・フレーズ', href: memorised_expressions_path
        click_link '英単語・フレーズ'
      end
      expect(page).to have_current_path root_path
      expect(all('li.expression').count).to eq 1
      within '.page_tabs' do
        click_link 'ブックマーク'
        click_link '覚えた英単語・フレーズ'
      end
      expect(page).to have_current_path memorised_expressions_path
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end
  end
end
