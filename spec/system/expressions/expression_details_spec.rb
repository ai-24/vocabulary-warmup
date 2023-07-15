# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'expressions/1' do
    it 'check url' do
      visit '/'
      click_link '試してみる(機能に制限あり)'
      expect(page).to have_current_path home_path
      click_link 'balcony and Veranda'
      expect(page).to have_content '下記の英単語・フレーズの違いについて'
      expect(page).to have_current_path expression_path(1), ignore_query: true
    end

    it 'show a title section' do
      visit '/'
      click_link '試してみる(機能に制限あり)'
      expect(page).to have_current_path home_path
      click_link 'balcony and Veranda'
      within '.title' do
        expect(page).to have_content '1. balcony'
        expect(page).to have_content '2. Veranda'
        expect(page).not_to have_content '4.'
      end
    end

    it 'show details of the first expression' do
      visit '/'
      click_link '試してみる(機能に制限あり)'
      expect(page).to have_current_path home_path
      click_link 'balcony and Veranda'
      within '.expression0' do
        expect(page).to have_content 'balcony'
        expect(page).to have_content 'A platform on the side of a building, accessible from inside the building.'
        expect(page).to have_content '例文'
        expect(page).to have_content "I'm drying my clothes on the balcony."
      end
    end

    it 'show details of the second expression' do
      visit '/'
      click_link '試してみる(機能に制限あり)'
      expect(page).to have_current_path home_path
      click_link 'balcony and Veranda'
      within '.expression1' do
        expect(page).to have_content 'Veranda'
        expect(page).to have_content 'A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to si'
        expect(page).to have_content '例文'
        expect(page).to have_content 'The postman left my parcel on the veranda.'
      end
    end

    it 'not to show a note and a tag if there are no data' do
      visit '/expressions/1'
      expect(page).not_to have_content 'メモ'
      expect(page).not_to have_content 'タグ'
    end

    it 'check the expression list after clicking the back button that goes to root path' do
      10.times do
        FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
        FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))
      end

      visit '/expressions/1'
      click_link '英単語・フレーズ一覧に戻る'
      expect(all('li.expression').count).to eq 21
      expect(first('li.expression')).to have_link 'balcony and Veranda', href: expression_path(1)
    end

    it 'check if there is no incremental search' do
      visit '/expressions/1'
      expect(page).not_to have_selector '.incremental-search'
    end
  end

  describe 'new expression with examples, a note and a tag' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end

      click_link '新規作成'
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
      within '.title' do
        expect(page).to have_content '1. on the beach'
        expect(page).to have_content '2. at the beach'
        expect(page).to have_content '3. around the beach'
      end
    end

    it 'show details of the third expression' do
      within '.expression2' do
        expect(page).to have_content 'around the beach'
        expect(page).to have_content 'explanation of around the beach'
      end
    end

    it 'check if examples of first expression are on the page' do
      within '.expression0' do
        expect(page).to have_content '例文'
        expect(page).to have_content 'example of on the beach'
      end
    end

    it 'check if examples of second expression are on the page' do
      within '.expression1' do
        expect(page).to have_content '例文'
        expect(page).to have_content 'example of at the beach'
      end
    end

    it 'check if a note is on the page' do
      within '.note' do
        expect(page).to have_content 'メモ'
        expect(page).to have_content 'note'
      end
    end

    it 'check if a tag is on the page' do
      within '.tag' do
        expect(page).to have_content 'タグ'
        expect(page).to have_content 'preposition'
      end
    end

    it 'check if there is incremental search' do
      expect(page).to have_selector '.incremental-search'
    end
  end

  describe 'next and back button' do
    context 'when the expressions is in words and phrases list' do
      it 'check if there is no next button when the expression is the last one' do
        first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))

        visit '/'
        click_link '試してみる(機能に制限あり)'
        expect(page).to have_current_path home_path
        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{first_expression_items[0].expression.id}", ignore_query: true
        expect(page).to have_link '１つ前の英単語・フレーズへ', href: '/expressions/1'
        expect(page).not_to have_link '次の英単語・フレーズへ'
      end

      it 'check if there is no back button when the expression is the first one' do
        expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))

        visit '/'
        click_link '試してみる(機能に制限あり)'
        expect(page).to have_current_path home_path
        click_link 'balcony and Veranda'
        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path '/expressions/1'
        expect(page).to have_link '次の英単語・フレーズへ', href: "/expressions/#{expression_items[0].expression.id}"
        expect(page).not_to have_link '１つ前の英単語・フレーズへ'
      end

      it 'check if there is no back and next button when expression is one in a list' do
        visit '/'
        click_link '試してみる(機能に制限あり)'
        expect(page).to have_current_path home_path
        click_link 'balcony and Veranda'
        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path '/expressions/1'
        expect(page).not_to have_link '１つ前の英単語・フレーズへ'
        expect(page).not_to have_link '次の英単語・フレーズへ'
      end

      it 'check next button' do
        first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
        second_expression_items = FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:note))

        visit '/'
        click_link '試してみる(機能に制限あり)'
        expect(page).to have_current_path home_path
        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{first_expression_items[0].expression.id}", ignore_query: true

        click_link '次の英単語・フレーズへ'
        expect(page).to have_content "1. #{second_expression_items[0].content}"
        expect(page).to have_current_path expression_path(second_expression_items[0].expression), ignore_query: true
      end

      it 'check back button' do
        first_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
        second_expression_items = FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:note))

        visit '/'
        click_link '試してみる(機能に制限あり)'
        expect(page).to have_current_path home_path
        click_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}"
        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{second_expression_items[0].expression.id}", ignore_query: true
        click_link '１つ前の英単語・フレーズへ'
        expect(page).to have_content "1. #{first_expression_items[0].content}"
        expect(page).to have_current_path expression_path(first_expression_items[0].expression), ignore_query: true
      end
    end

    context 'when the expressions is in bookmarked expressions list' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item3, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      before do
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        within '.button-on-header' do
          click_button 'Sign up/Log in with Google'
        end
      end

      it 'check next button' do
        expect(page).to have_content 'ログインしました'
        visit '/bookmarked_expressions'
        click_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{second_expression_items[0].expression.id}", ignore_query: true
        expect(page).to have_link '１つ前の英単語・フレーズへ'
        expect(page).to have_link '次の英単語・フレーズへ'
        click_link '次の英単語・フレーズへ'

        expect(page).to have_content "1. #{third_expression_items[0].content}"
        expect(page).to have_current_path "/expressions/#{third_expression_items[0].expression.id}", ignore_query: true
      end

      it 'check back button' do
        expect(page).to have_content 'ログインしました'
        visit '/bookmarked_expressions'
        click_link "#{third_expression_items[0].content} and #{third_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{third_expression_items[0].expression.id}", ignore_query: true
        expect(page).to have_link '１つ前の英単語・フレーズへ'
        click_link '１つ前の英単語・フレーズへ'

        expect(page).to have_content "1. #{second_expression_items[0].content}"
        expect(page).to have_current_path "/expressions/#{second_expression_items[0].expression.id}", ignore_query: true
      end

      it 'check if there is no next button when the expression is the last one' do
        expect(page).to have_content 'ログインしました'
        visit '/bookmarked_expressions'
        click_link "#{third_expression_items[0].content} and #{third_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{third_expression_items[0].expression.id}", ignore_query: true
        expect(page).not_to have_link '次の英単語・フレーズへ'
      end

      it 'check if there is no back button if the expression is the first one' do
        expect(page).to have_content 'ログインしました'
        visit '/bookmarked_expressions'
        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{first_expression_items[0].expression.id}", ignore_query: true
        expect(page).not_to have_link '１つ前の英単語・フレーズへ'
      end

      it 'check if there is no back and next button when expression is one in a list' do
        expect(page).to have_content 'ログインしました'
        first_expression_items[0].expression.destroy
        third_expression_items[0].expression.destroy
        expect(User.find(user.id).bookmarkings.count).to eq 1

        visit '/bookmarked_expressions'
        click_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{second_expression_items[0].expression.id}", ignore_query: true
        expect(page).not_to have_link '１つ前の英単語・フレーズへ'
        expect(page).not_to have_link '次の英単語・フレーズへ'
      end
    end

    context 'when the expression is in memorised expression list' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item3, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      before do
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        within '.button-on-header' do
          click_button 'Sign up/Log in with Google'
        end
      end

      it 'check next button' do
        expect(page).to have_content 'ログインしました'
        visit '/memorised_expressions'
        click_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{second_expression_items[0].expression.id}", ignore_query: true
        expect(page).to have_link '１つ前の英単語・フレーズへ'
        expect(page).to have_link '次の英単語・フレーズへ'
        click_link '次の英単語・フレーズへ'

        expect(page).to have_content "1. #{third_expression_items[0].content}"
        expect(page).to have_current_path "/expressions/#{third_expression_items[0].expression.id}", ignore_query: true
      end

      it 'check back button' do
        expect(page).to have_content 'ログインしました'
        visit '/memorised_expressions'
        click_link "#{third_expression_items[0].content} and #{third_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{third_expression_items[0].expression.id}", ignore_query: true
        expect(page).to have_link '１つ前の英単語・フレーズへ'
        click_link '１つ前の英単語・フレーズへ'

        expect(page).to have_content "1. #{second_expression_items[0].content}"
        expect(page).to have_current_path "/expressions/#{second_expression_items[0].expression.id}", ignore_query: true
      end

      it 'check if there is no next button when the expression is the last one' do
        expect(page).to have_content 'ログインしました'
        visit '/memorised_expressions'
        click_link "#{third_expression_items[0].content} and #{third_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{third_expression_items[0].expression.id}", ignore_query: true
        expect(page).not_to have_link '次の英単語・フレーズへ'
      end

      it 'check if there is no back button if the expression is the first one' do
        expect(page).to have_content 'ログインしました'
        visit '/memorised_expressions'
        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{first_expression_items[0].expression.id}", ignore_query: true
        expect(page).not_to have_link '１つ前の英単語・フレーズへ'
      end

      it 'check if there is no back and next button when expression is one in a list' do
        expect(page).to have_content 'ログインしました'
        first_expression_items[0].expression.destroy
        third_expression_items[0].expression.destroy
        expect(User.find(user.id).memorisings.count).to eq 1

        visit '/memorised_expressions'
        click_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}"

        expect(page).to have_content '下記の英単語・フレーズの違いについて'
        expect(page).to have_current_path "/expressions/#{second_expression_items[0].expression.id}", ignore_query: true
        expect(page).not_to have_link '１つ前の英単語・フレーズへ'
        expect(page).not_to have_link '次の英単語・フレーズへ'
      end
    end
  end

  describe 'authority' do
    let!(:user) { FactoryBot.create(:user) }
    let(:new_user) { FactoryBot.build(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    it 'check if user who does not own the expressions can not see it' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

      visit '/'
      within '.welcome' do
        click_button 'Sign up/Log in with Google'
      end
      expect(page).to have_content 'ログインしました'

      visit "/expressions/#{first_expression_items[0].expression.id}"
      expect(page).to have_current_path home_path
      expect(page).to have_content '権限がないため閲覧できません'
      within '.error' do
        expect(page).not_to have_button 'Sign up/Log in with Google'
      end

      visit "/expressions/#{second_expression_items[0].expression.id}"
      expect(page).to have_current_path home_path
      expect(page).to have_content '権限がないため閲覧できません'
    end

    it 'check if the user who owns the expressions can see it' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      within '.button-on-header' do
        click_button 'Sign up/Log in with Google'
      end
      expect(page).to have_content 'ログインしました'
      visit "/expressions/#{first_expression_items[0].expression.id}"

      within '.title' do
        expect(page).to have_content "1. #{first_expression_items[0].content}"
        expect(page).to have_content "2. #{first_expression_items[1].content}"
      end
    end

    it 'check if the user can not see their expression without login' do
      visit "/expressions/#{first_expression_items[0].expression.id}"
      expect(page).to have_content 'ログインが必要です'
      expect(page).to have_current_path root_path
      within '.error' do
        expect(page).to have_button 'Sign up/Log in with Google'
      end
    end
  end
end
