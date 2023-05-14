# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memorised expressions' do
  context 'when user logged in' do
    context 'when there are no data of memorisings' do
      let(:user) { FactoryBot.build(:user) }

      before do
        FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note))
        FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note))

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
      end

      it 'show a message that there are no data' do
        visit '/memorised_expressions'
        expect(page).to have_content user.name
        expect(all('li').count).to eq 0
        expect(page).to have_content '覚えた語彙リストに登録している英単語またはフレーズはありません'
      end
    end

    context 'when there are data of memorisings' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      before do
        expressions = []
        10.times do
          expressions.push(FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)))
        end

        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)
        10.times do |n|
          FactoryBot.create(:memorising, user:, expression: expressions[n][0].expression)
        end

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
      end

      it 'show a list of memorised expressions' do
        expect(page).to have_content 'ログインしました'
        visit '/memorised_expressions'

        expect(all('li').count).to eq 12
        expect(page).not_to have_content '覚えた語彙リストに登録している英単語またはフレーズはありません'
        expect(page).not_to have_content 'ログインしていないため閲覧できません'
      end

      it 'check titles and links' do
        expect(page).to have_content 'ログインしました'
        visit '/memorised_expressions'

        expect(first('li')).to have_link "#{first_expression_items[0].content}, #{first_expression_items[1].content} and #{first_expression_items[2].content}",
                                         href: expression_path(first_expression_items[0].expression)
        expect(all('li')[1]).to have_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}",
                                          href: expression_path(second_expression_items[0].expression)
      end
    end

    context 'when memorisings were made by two different times' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      before do
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'

        visit '/quiz'

        2.times do |n|
          if has_text?(first_expression_items[0].explanation)
            fill_in('解答を入力', with: first_expression_items[0].content)
          elsif has_text?(first_expression_items[1].explanation)
            fill_in('解答を入力', with: first_expression_items[1].content)
          end
          click_button 'クイズに解答する'
          n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
        end
        click_button '保存する'

        visit '/memorised_expressions'
      end

      it 'check order' do
        expect(first('li')).to have_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}",
                                         href: expression_path(ExpressionItem.where(content: second_expression_items[0].content).last.expression)
        expect(all('li')[1]).to have_link "#{third_expression_items[0].content}, #{third_expression_items[1].content} and #{third_expression_items[2].content}",
                                          href: expression_path(ExpressionItem.where(content: third_expression_items[0].content).last.expression)
        expect(all('li').last).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}",
                                            href: expression_path(ExpressionItem.where(content: first_expression_items[0].content).last.expression)
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

      visit '/quiz'

      2.times do |n|
        if has_text?('A platform on the side of a building, accessible from inside the building.')
          fill_in('解答を入力', with: 'balcony')
        else
          fill_in('解答を入力', with: 'veranda')
        end
        click_button 'クイズに解答する'
        n < 1 ? click_button('次へ') : click_button('クイズの結果を確認する')
      end
      click_button '保存する'

      find('label', text: user.name).click
      click_button 'Log out'
    end

    it 'show message that is not logged in' do
      expect(page).to have_content 'ログアウトしました'

      visit '/memorised_expressions'
      expect(page).to have_button 'Sign up/Log in with Google'
      expect(all('li').count).to eq 0
      expect(page).to have_content 'ログインしていないため閲覧できません'
    end
  end
end
