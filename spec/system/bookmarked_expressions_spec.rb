# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarked expressions' do
  context 'when user logged in' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:expression) { FactoryBot.create(:empty_note, user_id: user.id) }
    let!(:first_expression_item) { FactoryBot.create(:expression_item, expression:) }
    let!(:second_expression_item) { FactoryBot.create(:expression_item2, expression:) }

    let!(:expression2) { FactoryBot.create(:empty_note, user_id: user.id) }
    let!(:third_expression_item) { FactoryBot.create(:expression_item3, expression: expression2) }
    let!(:fourth_expression_item) { FactoryBot.create(:expression_item4, expression: expression2) }

    let!(:expression3) { FactoryBot.create(:empty_note, user_id: user.id) }
    let!(:fifth_expression_item) { FactoryBot.create(:expression_item5, expression: expression3) }
    let!(:sixth_expression_item) { FactoryBot.create(:expression_item6, expression: expression3) }
    let!(:seventh_expression_item) { FactoryBot.create(:expression_item, content: Faker::Job.field, explanation: Faker::Quote.yoda, expression: expression3) }

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
          expect(page).to have_link '覚えた語彙', href: memorised_expressions_path
          find('a.words-and-phrases-link', text: '英単語・フレーズ').click
        end
        expect(page).to have_current_path root_path
        expect(all('li.expression').count).to eq 3
        within '.page_tabs' do
          click_link 'ブックマーク'
          click_link '覚えた語彙'
        end
        expect(page).to have_current_path memorised_expressions_path
        expect(page).to have_content 'このリストに登録している英単語またはフレーズはありません'
      end
    end

    context 'when there are bookmarks' do
      it 'show a list of bookmarked expressions' do
        expect(page).to have_content 'ログインしました'
        visit '/quiz'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content 'ブックマークしました！'

        visit '/bookmarked_expressions'

        expect(page).to have_selector '.incremental-search'
        expect(all('li.expression').count).to eq 3
        expect(page).not_to have_content 'ブックマークしている英単語またはフレーズはありません'
        expect(page).not_to have_content 'ログインしていないため閲覧できません'
      end

      it 'check titles and links' do
        expect(page).to have_content 'ログインしました'
        visit '/quiz'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content 'ブックマークしました！'

        visit '/bookmarked_expressions'

        expect(all('li.expression').count).to eq 3
        expect(first('li.expression')).to have_link "#{first_expression_item.content} and #{second_expression_item.content}",
                                                    href: expression_path(expression)
        expect(all('li.expression')[1]).to have_link "#{third_expression_item.content} and #{fourth_expression_item.content}",
                                                     href: expression_path(expression2)
        expect(all('li.expression')[2]).to have_link(
          "#{fifth_expression_item.content}, #{sixth_expression_item.content} and #{seventh_expression_item.content}", href: expression_path(expression3)
        )
      end

      it 'check tabs' do
        expect(page).to have_content 'ログインしました'
        visit '/quiz'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content 'ブックマークしました！'

        visit '/bookmarked_expressions'

        within '.page_tabs' do
          expect(page).to have_link '英単語・フレーズ', href: root_path
          expect(page).to have_link 'ブックマーク', href: bookmarked_expressions_path
          expect(page).to have_link '覚えた語彙', href: memorised_expressions_path
        end
      end
    end

    context 'when bookmarks were made by two different times' do
      it 'check order' do
        expect(page).to have_content 'ログインしました'
        visit '/quiz'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        find('summary', text: 'ブックマークする英単語・フレーズ').click
        find('label', text: "#{first_expression_item.content} and #{second_expression_item.content}").click
        click_button '保存する'
        expect(page).to have_content 'ブックマークしました！'

        click_button 'クイズに再挑戦'
        2.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content 'ブックマークしました！'

        visit '/bookmarked_expressions'

        expect(first('li.expression')).to have_link "#{third_expression_item.content} and #{fourth_expression_item.content}",
                                                    href: expression_path(expression2)
        expect(all('li.expression')[1]).to have_link(
          "#{fifth_expression_item.content}, #{sixth_expression_item.content} and #{seventh_expression_item.content}",
          href: expression_path(expression3)
        )
        expect(all('li.expression').last).to have_link "#{first_expression_item.content} and #{second_expression_item.content}",
                                                       href: expression_path(expression)
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
        click_button 'クイズに解答する'
        has_text? '×'
        n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      click_button '保存する'
      has_text? 'ブックマークしました！'

      visit '/'
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
        expect(page).to have_link '覚えた語彙', href: memorised_expressions_path
        find('a.words-and-phrases-link', text: '英単語・フレーズ').click
      end
      expect(page).to have_current_path root_path
      expect(all('li.expression').count).to eq 1
      within '.page_tabs' do
        click_link 'ブックマーク'
        click_link '覚えた語彙'
      end
      expect(page).to have_current_path memorised_expressions_path
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end

    it 'check if there is no incremental search' do
      expect(page).to have_content 'ログアウトしました'
      visit '/bookmarked_expressions'
      expect(page).not_to have_selector '.incremental-search'
    end
  end
end
