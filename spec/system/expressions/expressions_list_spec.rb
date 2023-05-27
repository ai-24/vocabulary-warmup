# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  context 'when user has not logged in' do
    let(:new_user) { FactoryBot.build(:user) }
    let!(:two_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:three_expression_items) { FactoryBot.create_list(:expression_item2, 3, expression: FactoryBot.create(:empty_note)) }
    let!(:four_expression_items) { FactoryBot.create_list(:expression_item3, 4, expression: FactoryBot.create(:empty_note)) }
    let!(:five_expression_items) { FactoryBot.create_list(:expression_item4, 5, expression: FactoryBot.create(:empty_note)) }

    before do
      16.times do
        FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
      end

      visit '/'
    end

    it 'show a list of expressions' do
      expect(all('li').count).to eq 21
    end

    it 'check the title and the link that is for two expression items' do
      expect(page).to have_link(
        "#{two_expression_items[0].content} and #{two_expression_items[1].content}", href: expression_path(two_expression_items[0].expression)
      )
    end

    it 'check the title and the link that is for three expression items' do
      title = "#{three_expression_items[0].content}, #{three_expression_items[1].content} and #{three_expression_items[2].content}"

      expect(page).to have_link title, href: expression_path(three_expression_items[0].expression)
    end

    it 'check the title and the link that is for four expression items' do
      item0 = four_expression_items[0]
      title = "#{item0.content}, #{four_expression_items[1].content}, #{four_expression_items[2].content} and #{four_expression_items[3].content}"

      expect(page).to have_link title, href: expression_path(four_expression_items[0].expression)
    end

    it 'check the title and the link that is for five expression items' do
      item0 = five_expression_items[0]
      item1 = five_expression_items[1]
      item2 = five_expression_items[2]
      title = "#{item0.content}, #{item1.content}, #{item2.content}, #{five_expression_items[3].content} and #{five_expression_items[4].content}"

      expect(page).to have_link title, href: expression_path(five_expression_items[0].expression)
    end
  end

  context 'when new user logged in' do
    let(:new_user) { FactoryBot.build(:user) }

    before do
      10.times do
        FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
        FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:empty_note))
      end

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
    end

    it 'show a list of expressions' do
      expect(page).to have_content 'ログインしました'

      expect(all('li').count).to eq 21
    end

    it 'check the list order before the note has been edited' do
      expression_item = ExpressionItem.where('content = ?', 'balcony').last

      expect(first('li')).to have_link 'balcony and Veranda', href: expression_path(expression_item.expression)
    end

    it 'check if the data is at the same place after the note has been edited' do
      click_link 'balcony and Veranda'
      click_link '編集'
      3.times { click_button '次へ' }
      fill_in('メモ（任意）', with: 'note is added')
      click_button '編集する'

      visit '/'
      expression_item = ExpressionItem.where('content = ?', 'balcony').last

      expect(first('li')).to have_link 'balcony and Veranda', href: expression_path(expression_item.expression)
    end
  end

  context 'when a user who has bookmarks has logged in' do
    let(:new_user) { FactoryBot.build(:user) }
    let!(:two_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:three_expression_items) { FactoryBot.create_list(:expression_item2, 3, expression: FactoryBot.create(:empty_note)) }
    let!(:four_expression_items) { FactoryBot.create_list(:expression_item3, 4, expression: FactoryBot.create(:empty_note)) }
    let!(:five_expression_items) { FactoryBot.create_list(:expression_item4, 5, expression: FactoryBot.create(:empty_note)) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      has_text? 'ログインしました'

      visit '/quiz'
      16.times do |n|
        click_button 'クイズに解答する'
        n < 15 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      find('input#move-to-bookmark').click
      find('summary', text: 'ブックマークする英単語・フレーズ').click
      find('label', text: 'balcony and Veranda').click
      find('label', text: "#{two_expression_items[0].content} and #{two_expression_items[1].content}").click
    end

    it 'check list of expressions' do
      click_button '保存する'
      expect(page).to have_content 'ブックマークしました！'

      visit '/'
      expect(all('li').count).to eq 3

      expect(first('li')).to have_link "#{three_expression_items[0].content}, #{three_expression_items[1].content} and #{three_expression_items[2].content}"

      expect(all('li')[1]).to have_link(
        "#{four_expression_items[0].content}, #{four_expression_items[1].content}, #{four_expression_items[2].content} and #{four_expression_items[3].content}"
      )

      item0 = five_expression_items[0]
      item1 = five_expression_items[1]
      expect(all('li')[2]).to have_link(
        "#{item0.content}, #{item1.content}, #{five_expression_items[2].content}, #{five_expression_items[3].content} and #{five_expression_items[4].content}"
      )
    end

    it 'check if list of expressions has no data after adding all expressions to bookmarks' do
      click_button '保存する'
      expect(page).to have_content 'ブックマークしました！'

      visit '/quiz'
      12.times do |n|
        fill_in('解答を入力', with: '')
        click_button 'クイズに解答する'
        n < 11 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      click_button '保存する'
      expect(page).to have_content 'ブックマークしました！'

      visit '/'
      expect(all('li').count).to eq 0
      expect(page).to have_content 'このリストに登録されている英単語またはフレーズはありません'
    end
  end

  context 'when a user who has memorised words logged in' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item2, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:expression) { FactoryBot.create(:empty_note, user_id: user.id) }
    let!(:first_expression_item) { FactoryBot.create(:expression_item3, expression:) }
    let!(:second_expression_item) { FactoryBot.create(:expression_item4, expression:) }

    before do
      FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
      FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)

      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
    end

    it 'check list of expressions' do
      expect(all('li').count).to eq 1
      expect(page).to have_link "#{first_expression_item.content} and #{second_expression_item.content}",
                                href: expression_path(ExpressionItem.where(content: first_expression_item.content).last.expression)
    end

    it 'check if list of expressions has no data after adding all expressions to memorised words list' do
      visit '/quiz'
      2.times do |n|
        if has_text?(first_expression_item.explanation)
          fill_in('解答を入力', with: first_expression_item.content)
        elsif has_text?(second_expression_item.explanation)
          fill_in('解答を入力', with: second_expression_item.content)
        end
        click_button 'クイズに解答する'
        n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      click_button '保存する'

      visit '/'
      expect(all('li').count).to eq 0
      expect(page).to have_content 'このリストに登録されている英単語またはフレーズはありません'
    end
  end
end
