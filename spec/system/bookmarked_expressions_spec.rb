# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarked expressions' do
  context 'when user logged in' do
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note)) }
    let(:user) { FactoryBot.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
    end

    context 'when there are no bookmarks' do
      it 'show a message that there are no bookmarks' do
        visit '/bookmarked_expressions'
        expect(page).to have_content user.name
        expect(all('li').count).to eq 0
        expect(page).to have_content 'ブックマークしている英単語またはフレーズはありません'
      end
    end

    context 'when there are bookmarks' do
      before do
        visit '/quiz'

        9.times do |n|
          fill_in('解答を入力', with: '')
          click_button 'クイズに解答する'
          n < 8 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end

        find('summary', text: 'ブックマークする英単語・フレーズ').click
        find('label', text: 'balcony and Veranda').click
        click_button '保存する'

        visit '/bookmarked_expressions'
      end

      it 'show a list of bookmarked expressions' do
        expect(all('li').count).to eq 3
        expect(page).not_to have_content 'ブックマークしている英単語またはフレーズはありません'
        expect(page).not_to have_content 'ログインしていないため閲覧できません'
      end

      it 'check titles and links' do
        expect(first('li')).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}",
                                         href: expression_path(first_expression_items[0].expression)
        expect(all('li')[1]).to have_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}",
                                          href: expression_path(second_expression_items[0].expression)
        expect(all('li')[2]).to have_link "#{third_expression_items[0].content}, #{third_expression_items[1].content} and #{third_expression_items[2].content}",
                                          href: expression_path(third_expression_items[0].expression)
        expect(page).not_to have_link 'balcony and Veranda'
      end
    end

    context 'when bookmarks were made by two different times' do
      before do
        visit '/quiz'

        9.times do |n|
          fill_in('解答を入力', with: '')
          click_button 'クイズに解答する'
          n < 8 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        find('summary', text: 'ブックマークする英単語・フレーズ').click
        find('label', text: 'balcony and Veranda').click
        click_button '保存する'

        visit '/quiz'
        9.times do |n|
          fill_in('解答を入力', with: '')
          click_button 'クイズに解答する'
          n < 8 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        find('label', text: '不正解だった英単語又はフレーズと、それと一緒に保存されている英単語・フレーズを全てブックマークする').click
        find('summary', text: 'ブックマークする英単語・フレーズ').click
        find('label', text: 'balcony and Veranda').click
        click_button '保存する'

        visit '/bookmarked_expressions'
      end

      it 'check order' do
        balcony = ExpressionItem.find_by content: 'balcony'
        expect(first('li')).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}",
                                         href: expression_path(first_expression_items[0].expression)
        expect(all('li')[1]).to have_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}",
                                          href: expression_path(second_expression_items[0].expression)
        expect(all('li')[2]).to have_link "#{third_expression_items[0].content}, #{third_expression_items[1].content} and #{third_expression_items[2].content}",
                                          href: expression_path(third_expression_items[0].expression)
        expect(all('li').last).to have_link 'balcony and Veranda', href: expression_path(balcony.expression)
      end
    end
  end

  context 'when user is not logged in' do
    let(:user) { FactoryBot.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'

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
      visit '/bookmarked_expressions'
      expect(page).to have_button 'Sign up/Log in with Google'
      expect(all('li').count).to eq 0
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end
  end
end
