# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarked expressions' do
  describe 'redirect' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
    end

    it 'check the page is redirected to 要復習リスト after login' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit home_path
      click_link '要復習'
      expect(page).to have_current_path bookmarked_expressions_path
      expect(page).to have_content 'ログインしていないため閲覧できません'
      within '.button-on-header' do
        click_button 'Sign up / Log in with Google'
      end
      expect(page).to have_content 'ログインしました'
      expect(page).to have_current_path bookmarked_expressions_path
      expect(all('li.expression').count).to eq 1
      expect(page).not_to have_content 'ログインしていないため閲覧できません'
    end
  end

  context 'when user who already has a bookmarking logged in' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)

      sign_in_with_welcome_page '.first-login-button', user
    end

    it 'check the link that goes to 要復習 list on expression detail page' do
      expect(page).to have_content 'ログインしました'
      click_link '要復習'
      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
      expect(page).to have_current_path expression_path(first_expression_items[0].expression)
      expect(page).to have_link '一覧に戻る'
      click_link '一覧に戻る'
      expect(page).to have_current_path bookmarked_expressions_path
    end
  end

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
      sign_in_with_welcome_page '.first-login-button', user
    end

    context 'when there are no bookmarkings' do
      it 'show a message that there are no bookmarkings' do
        expect(page).to have_content 'ログインしました'
        click_link '要復習'
        expect(page).to have_current_path bookmarked_expressions_path
        expect(page).to have_content user.name
        expect(all('li.expression').count).to eq 0
        expect(page).to have_content 'このリストに登録している英単語・フレーズはありません'
      end

      it 'check tabs' do
        expect(page).to have_content 'ログインしました'
        click_link '要復習'

        within '.page_tabs' do
          expect(page).to have_link '未分類', href: home_path
          expect(page).to have_link '要復習', href: bookmarked_expressions_path
          expect(page).to have_link '覚えた', href: memorised_expressions_path
          find('a.words-and-phrases-link', text: '未分類').click
        end
        expect(page).to have_current_path home_path
        expect(all('li.expression').count).to eq 3
        within '.page_tabs' do
          click_link '要復習'
          click_link '覚えた'
        end
        expect(page).to have_current_path memorised_expressions_path
        expect(page).to have_content 'このリストに登録している英単語・フレーズはありません'
      end
    end

    context 'when there are bookmarkings' do
      it 'show a list of 要復習' do
        expect(page).to have_content 'ログインしました'
        click_link 'クイズに挑戦'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content '要復習リストに英単語・フレーズを保存しました！'

        visit '/bookmarked_expressions'

        expect(page).to have_selector '.incremental-search'
        expect(all('li.expression').count).to eq 3
        expect(page).not_to have_content 'このリストに登録している英単語・フレーズはありません'
        expect(page).not_to have_content 'ログインしていないため閲覧できません'
      end

      it 'check titles and links' do
        expect(page).to have_content 'ログインしました'
        click_link 'クイズに挑戦'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content '要復習リストに英単語・フレーズを保存しました！'

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
        click_link 'クイズに挑戦'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content '要復習リストに英単語・フレーズを保存しました！'

        visit '/bookmarked_expressions'

        within '.page_tabs' do
          expect(page).to have_link '未分類', href: home_path
          expect(page).to have_link '要復習', href: bookmarked_expressions_path
          expect(page).to have_link '覚えた', href: memorised_expressions_path
        end
      end
    end

    context 'when bookmarks were made by two different times' do
      it 'check order' do
        expect(page).to have_content 'ログインしました'
        click_link 'クイズに挑戦'

        7.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 6 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        find('summary', text: '要復習リストに保存する英単語・フレーズ').click
        find('label', text: "#{first_expression_item.content} and #{second_expression_item.content}").click
        click_button '保存する'
        expect(page).to have_content '要復習リストに英単語・フレーズを保存しました！'

        click_button 'クイズに再挑戦'
        2.times do |n|
          expect(page).to have_selector 'p.content-of-question'
          click_button 'クイズに解答する'
          expect(page).to have_content '×'
          n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'
        expect(page).to have_content '要復習リストに英単語・フレーズを保存しました！'

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
      sign_in_with_welcome_page '.first-login-button', user
      has_text? 'ログインしました'

      visit '/quiz'

      2.times do |n|
        click_button 'クイズに解答する'
        has_text? '×'
        n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      click_button '保存する'
      has_text? '要復習リストに保存しました！'

      visit '/home'
      find('label', text: user.name).click
      click_button 'Log out'
    end

    it 'show message that is not logged in' do
      expect(page).to have_content 'ログアウトしました'
      within '.recommended-users' do
        click_link '試してみる'
      end
      expect(page).to have_current_path home_path
      click_link '要復習'
      expect(page).to have_current_path bookmarked_expressions_path
      expect(page).to have_button 'Sign up / Log in with Google'
      expect(all('li.expression').count).to eq 0
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end

    it 'check tabs' do
      expect(page).to have_content 'ログアウトしました'
      within '.without-login' do
        click_link '試してみる'
      end
      expect(page).to have_current_path home_path
      click_link '要復習'

      within '.page_tabs' do
        expect(page).to have_link '未分類', href: home_path
        expect(page).to have_link '要復習', href: bookmarked_expressions_path
        expect(page).to have_link '覚えた', href: memorised_expressions_path
        find('a.words-and-phrases-link', text: '未分類').click
      end
      expect(page).to have_current_path home_path
      expect(all('li.expression').count).to eq 1
      within '.page_tabs' do
        click_link '要復習'
        click_link '覚えた'
      end
      expect(page).to have_current_path memorised_expressions_path
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end

    it 'check if there is no incremental search' do
      expect(page).to have_content 'ログアウトしました'
      within '.without-login' do
        click_link '試してみる'
      end
      expect(page).to have_current_path home_path
      click_link '要復習'
      expect(page).not_to have_selector '.incremental-search'
    end
  end
end
