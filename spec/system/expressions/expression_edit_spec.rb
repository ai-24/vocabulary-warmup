# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'links' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      sign_in_with_header '/', user
      has_text? 'ログインしました'

      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
      click_link '編集'
    end

    it 'check links' do
      expect(page).to have_current_path edit_expression_path(first_expression_items[0].expression)
      click_link '一覧に戻る'
      expect(page).to have_current_path home_path
      expect(page).to have_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}",
                                href: expression_path(first_expression_items[0].expression)
    end
  end

  describe 'authority' do
    let(:new_user) { FactoryBot.build(:user) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    it 'check if edit button is not on the page when user has not logged in' do
      visit '/'
      click_link '試してみる(機能に制限あり)'
      expect(page).to have_current_path home_path
      click_link 'balcony and veranda'
      expect(page).not_to have_link '編集'
    end

    it "check if edit button is not on the page that expression's user_id is nil when user logged in" do
      sign_in_with_welcome_page new_user
      expect(page).to have_content 'ログインしました'
      visit '/expressions/1'
      expect(page).not_to have_link '編集'
    end

    it 'check if edit button is on the page that expression is owned by user who logged in' do
      sign_in_with_header '/', user
      expect(page).to have_content 'ログインしました'

      click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
      expect(page).to have_link '編集'
    end
  end

  describe 'redirect' do
    let(:new_user) { FactoryBot.build(:user) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    it 'check if it is root_path when user access to edit url without login' do
      visit "/expressions/#{first_expression_items[0].expression.id}/edit"
      expect(page).to have_current_path root_path
      expect(page).to have_content 'ログインが必要です'
      within '.error' do
        expect(page).to have_button 'Sign up/Log in with Google'
      end
    end

    it 'check if it is home_path when user access to edit url of expression that user_id is nil when the user logged in' do
      sign_in_with_welcome_page new_user
      expect(page).to have_content 'ログインしました'

      visit '/expressions/1/edit'
      expect(page).to have_current_path home_path
      expect(page).to have_content '権限がありません'
      within '.error' do
        expect(page).not_to have_button 'Sign up/Log in with Google'
      end
    end

    it 'check if it is home_path when user access to edit url of expression that is owned by another user' do
      sign_in_with_welcome_page new_user
      expect(page).to have_content 'ログインしました'
      visit edit_expression_path(first_expression_items[0].expression)
      expect(page).to have_current_path home_path
      expect(page).to have_content '権限がありません'
    end
  end

  describe 'get the right data that has not been edited yet to edit' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      sign_in_with_header '/', user
      has_text? 'ログインしました'

      visit '/expressions/new'
      fill_in('英単語 / フレーズ１', with: 'on the beach')
      fill_in('英単語 / フレーズ２', with: 'at the beach')
      fill_in('英単語 / フレーズ３(任意)', with: 'around the beach')
      fill_in('英単語 / フレーズ４(任意)', with: 'of the beach')
      fill_in('英単語 / フレーズ５(任意)', with: 'in the beach')
      click_button '次へ'
      fill_in('on the beachの意味や前ページで登録した他の英単語 / フレーズ（at the beach, around the beach, of the beach, in the beach）との違いを入力してください',
              with: 'explanation of on the beach')
      fill_in('例文１', with: 'example1 of on the beach')
      fill_in('例文２', with: 'example2 of on the beach')
      fill_in('例文３', with: 'example3 of on the beach')
      click_button '次へ'
      fill_in('at the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, around the beach, of the beach, in the beach）との違いを入力してください',
              with: 'explanation of at the beach')
      fill_in('例文１', with: 'example1 of at the beach')
      fill_in('例文２', with: 'example2 of at the beach')
      fill_in('例文３', with: 'example3 of at the beach')
      click_button '次へ'
      fill_in('around the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach, of the beach, in the beach）との違いを入力してください',
              with: 'explanation of around the beach')
      fill_in('例文１', with: 'example1 of around the beach')
      fill_in('例文２', with: 'example2 of around the beach')
      fill_in('例文３', with: 'example3 of around the beach')
      click_button '次へ'
      fill_in('of the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach, around the beach, in the beach）との違いを入力してください',
              with: 'explanation of of the beach')
      click_button '次へ'
      fill_in('in the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach, around the beach, of the beach）との違いを入力してください',
              with: 'explanation of in the beach')
      click_button '次へ'
      fill_in('メモ（任意）', with: 'note')
      fill_in('タグ（任意）', with: 'preposition')
      find('input#tags').send_keys :return
      click_button '登録'

      click_link '編集'
    end

    it 'check if data of expression_items content is on the first page' do
      expect(page).to have_field('英単語 / フレーズ１', with: 'on the beach')
      expect(page).to have_field('英単語 / フレーズ２', with: 'at the beach')
      expect(page).to have_field('英単語 / フレーズ３(任意)', with: 'around the beach')
      expect(page).to have_field('英単語 / フレーズ４(任意)', with: 'of the beach')
      expect(page).to have_field('英単語 / フレーズ５(任意)', with: 'in the beach')
    end

    it 'check if explanation and examples are on the second page' do
      click_button '次へ'
      expect(page).to have_field('on the beachの意味や前ページで登録した他の英単語 / フレーズ（at the beach, around the beach, of the beach, in the beach）との違いを入力してください',
                                 with: 'explanation of on the beach')
      expect(page).to have_field('例文１', with: 'example1 of on the beach')
      expect(page).to have_field('例文２', with: 'example2 of on the beach')
      expect(page).to have_field('例文３', with: 'example3 of on the beach')
    end

    it 'check if explanation and examples are on the third page' do
      2.times { click_button '次へ' }

      expect(page).to have_field('at the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, around the beach, of the beach, in the beach）との違いを入力してください',
                                 with: 'explanation of at the beach')
      expect(page).to have_field('例文１', with: 'example1 of at the beach')
      expect(page).to have_field('例文２', with: 'example2 of at the beach')
      expect(page).to have_field('例文３', with: 'example3 of at the beach')
    end

    it 'check if explanation and examples are on the fourth page' do
      3.times { click_button '次へ' }

      expect(page).to have_field('around the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach, of the beach, in the beach）との違いを入力してください',
                                 with: 'explanation of around the beach')
      expect(page).to have_field('例文１', with: 'example1 of around the beach')
      expect(page).to have_field('例文２', with: 'example2 of around the beach')
      expect(page).to have_field('例文３', with: 'example3 of around the beach')
    end

    it 'check if data of explanation is on the fifth page' do
      4.times { click_button '次へ' }

      expect(page).to have_field('of the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach, around the beach, in the beach）との違いを入力してください',
                                 with: 'explanation of of the beach')
    end

    it 'check if data of explanation is on the sixth page' do
      5.times { click_button '次へ' }

      expect(page).to have_field('in the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach, around the beach, of the beach）との違いを入力してください',
                                 with: 'explanation of in the beach')
    end

    it 'check if date of note and the tag are on the last page' do
      6.times { click_button '次へ' }

      expect(page).to have_field('メモ（任意）', with: 'note')
      within 'li.tags' do
        expect(page).to have_content 'preposition'
      end
    end
  end

  describe 'get the right data which are already edited with right order to edit' do
    describe 'content and explanation of expression_items' do
      let(:user) { FactoryBot.build(:user) }

      before do
        sign_in_with_welcome_page user
        has_text? 'ログインしました'

        click_link 'balcony and veranda'
        click_link '編集'
        fill_in('英単語 / フレーズ１', with: 'journey')
        click_button '次へ'
        fill_in('journeyの意味や前ページで登録した他の英単語 / フレーズ（veranda）との違いを入力してください', with: 'Travelling but this word means more broad.')
        fill_in('例文１', with: 'The journey was tiring.')
        2.times { click_button '次へ' }
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'
      end

      it 'check if content of expression_items are correct order on editing page after it is edited' do
        click_link '編集'

        expect(page).to have_field('英単語 / フレーズ１', with: 'journey')
        expect(page).to have_field('英単語 / フレーズ２', with: 'veranda')
      end

      it 'check if explanations are correct order on editing page after it is edited' do
        click_link '編集'
        click_button '次へ'

        expect(page).to have_field('journeyの意味や前ページで登録した他の英単語 / フレーズ（veranda）との違いを入力してください',
                                   with: 'Travelling but this word means more broad.')
        expect(page).to have_field('例文１', with: 'The journey was tiring.')
        click_button '次へ'

        expect(page).to have_field(
          'verandaの意味や前ページで登録した他の英単語 / フレーズ（journey）との違いを入力してください',
          with: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.'
        )
      end
    end

    describe 'examples' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        sign_in_with_header '/', user
        has_text? 'ログインしました'

        click_link '新規作成'
        fill_in('英単語 / フレーズ１', with: 'on the beach')
        fill_in('英単語 / フレーズ２', with: 'at the beach')
        click_button '次へ'
        fill_in('on the beachの意味や前ページで登録した他の英単語 / フレーズ（at the beach）との違いを入力してください', with: 'explanation of on the beach')
        fill_in('例文１', with: 'example1 of on the beach')
        fill_in('例文２', with: 'example2 of on the beach')
        fill_in('例文３', with: 'example3 of on the beach')
        click_button '次へ'
        fill_in('at the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach）との違いを入力してください', with: 'explanation of at the beach')
        click_button '次へ'
        click_button '登録'

        click_link '編集'
        click_button '次へ'
        fill_in('例文１', with: 'test1')
        fill_in('例文２', with: 'test2')
        2.times { click_button '次へ' }
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'
      end

      it 'check if examples are correct order on edit page after it is edited' do
        click_link '編集'
        click_button '次へ'

        expect(page).to have_field('例文１', with: 'test1')
        expect(page).to have_field('例文２', with: 'test2')
        expect(page).to have_field('例文３', with: 'example3 of on the beach')
      end
    end
  end

  describe 'edit expressions' do
    context 'when first expression is edited and example is added' do
      let(:user) { FactoryBot.build(:user) }

      before do
        sign_in_with_welcome_page user
        has_text? 'ログインしました'

        click_link 'balcony and veranda'
        click_link '編集'
        fill_in('英単語 / フレーズ１', with: 'journey')
        click_button '次へ'
        fill_in('journeyの意味や前ページで登録した他の英単語 / フレーズ（veranda）との違いを入力してください', with: 'Travelling but this word means more broad.')
        fill_in('例文１', with: 'The journey was tiring.')
        2.times { click_button '次へ' }
      end

      it 'check if database does not create data when editing' do
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(Example, :count).by(0)
      end

      it 'check if the word which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.title div' do
          expect(page).to have_content '1. journey'
          expect(page).not_to have_content 'balcony'
        end

        within '.details div.expression0' do
          expect(page).to have_content(/^journey$/)
        end
      end

      it 'check if the explanation which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details div.expression0' do
          expect(page).to have_content 'Travelling but this word means more broad.'
          expect(page).not_to have_content 'A platform on the side of a building, accessible from inside the building.'
        end
      end

      it 'check if the example is on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details div.expression0' do
          expect(page).to have_content 'The journey was tiring.'
        end
      end
    end

    context 'when second word is edited and examples are added' do
      let(:user) { FactoryBot.build(:user) }

      before do
        sign_in_with_welcome_page user
        has_text? 'ログインしました'

        click_link 'balcony and veranda'
        click_link '編集'
        fill_in('英単語 / フレーズ２', with: 'Veranda')
        2.times { click_button '次へ' }
        fill_in('Verandaの意味や前ページで登録した他の英単語 / フレーズ（balcony）との違いを入力してください',
                with: 'normally on the ground floor and generally quite ornate or fancy, with room to sit. This sentence is added.')
        fill_in('例文１', with: 'test1')
        fill_in('例文２', with: 'test2')
        fill_in('例文３', with: 'test3')
        click_button '次へ'
      end

      it 'check if database does not create data when editing' do
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(Example, :count).by(2)
      end

      it 'check if the word which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.title div' do
          expect(page).to have_content '2. Veranda'
          expect(page).not_to have_content 'veranda'
        end

        within '.details div.expression1' do
          expect(page).to have_content 'Veranda'
        end
      end

      it 'check if the explanation which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details div.expression1' do
          expect(page).to have_content 'normally on the ground floor and generally quite ornate or fancy, with room to sit. This sentence is added.'
        end
      end

      it 'check if the example is on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details div.expression1' do
          expect(page).to have_content 'test1'
          expect(page).to have_content 'test2'
          expect(page).to have_content 'test3'
        end
      end
    end

    context 'when the third word, explanation, examples and note are edited' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        sign_in_with_header '/', user
        has_text? 'ログインしました'
        click_link '新規作成'

        fill_in('英単語 / フレーズ１', with: 'on the beach')
        fill_in('英単語 / フレーズ２', with: 'at the beach')
        fill_in('英単語 / フレーズ３(任意)', with: 'around the beach')
        click_button '次へ'
        fill_in('on the beachの意味や前ページで登録した他の英単語 / フレーズ（at the beach, around the beach）との違いを入力してください', with: 'explanation of on the beach')
        click_button '次へ'
        fill_in('at the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, around the beach）との違いを入力してください', with: 'explanation of at the beach')
        click_button '次へ'
        fill_in('around the beachの意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach）との違いを入力してください', with: 'explanation of around the beach')
        fill_in('例文１', with: 'example1 of around the beach')
        fill_in('例文２', with: 'example2 of around the beach')
        fill_in('例文３', with: 'example3 of around the beach')
        click_button '次へ'
        fill_in('メモ（任意）', with: 'note')
        fill_in('タグ（任意）', with: 'test')
        click_button '登録'

        click_link '編集'
        fill_in('英単語 / フレーズ３(任意)', with: 'test3')
        3.times { click_button '次へ' }
        fill_in('test3の意味や前ページで登録した他の英単語 / フレーズ（on the beach, at the beach）との違いを入力してください', with: 'explanation of test3')
        fill_in('例文１', with: 'test1')
        fill_in('例文２', with: 'test2')
        click_button '次へ'
        fill_in('メモ（任意）', with: 'note. note is added.')
      end

      it 'check if database does not create data when editing' do
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(Example, :count).by(0).and change(
          Tag, :count
        ).by(0).and change(Tagging, :count).by(0)
      end

      it 'check if the word which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.title div' do
          expect(page).to have_content '3. test3'
          expect(page).not_to have_content 'around the beach'
        end

        within '.details div.expression2 p.content' do
          expect(page).to have_content 'test3'
          expect(page).not_to have_content 'around the beach'
        end
      end

      it 'check if the explanation which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details div.expression2 p.explanation' do
          expect(page).to have_content 'explanation of test3'
        end
      end

      it 'check if the example which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within first('.details div.expression2 p.example') do
          expect(page).to have_content 'test1'
        end

        within all('.details div.expression2 p.example')[1] do
          expect(page).to have_content 'test2'
        end

        within all('.details div.expression2 p.example')[2] do
          expect(page).to have_content 'example3 of around the beach'
        end
      end

      it 'check if note which is already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within first('.note') do
          expect(page).to have_content 'note. note is added.'
        end
      end
    end

    context 'when expressions are added' do
      let(:user) { FactoryBot.build(:user) }

      before do
        sign_in_with_welcome_page user
        has_text? 'ログインしました'

        click_link 'balcony and veranda'
        click_link '編集'
        fill_in('英単語 / フレーズ３(任意)', with: 'test3')
        fill_in('英単語 / フレーズ４(任意)', with: 'test4')
        fill_in('英単語 / フレーズ５(任意)', with: 'test5')
        3.times { click_button '次へ' }
        fill_in('test3の意味や前ページで登録した他の英単語 / フレーズ（balcony, veranda, test4, test5）との違いを入力してください', with: 'explanation of test3')
        fill_in('例文１', with: 'test3 example1')
        fill_in('例文２', with: 'test3 example2')
        fill_in('例文３', with: 'test3 example3')
        click_button '次へ'
        fill_in('test4の意味や前ページで登録した他の英単語 / フレーズ（balcony, veranda, test3, test5）との違いを入力してください', with: 'explanation of test4')
        fill_in('例文１', with: 'test4 example1')
        fill_in('例文２', with: 'test4 example2')
        fill_in('例文３', with: 'test4 example3')
        click_button '次へ'
        fill_in('test5の意味や前ページで登録した他の英単語 / フレーズ（balcony, veranda, test3, test4）との違いを入力してください', with: 'explanation of test5')
        fill_in('例文１', with: 'test5 example1')
        fill_in('例文２', with: 'test5 example2')
        fill_in('例文３', with: 'test5 example3')
        click_button '次へ'
        fill_in('メモ（任意）', with: 'note')
        fill_in('タグ（任意）', with: 'tag')
      end

      it 'check if new data are created' do
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(3).and change(Example, :count).by(9).and change(Tag, :count).by(1)
      end

      it 'check if the new words are at title section on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.title div' do
          expect(page).to have_content 'test3'
          expect(page).to have_content 'test4'
          expect(page).to have_content 'test5'
        end
      end

      it 'check if the new words are at detail section on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details div.expression2' do
          expect(page).to have_content 'test3'
        end

        within '.details div.expression3' do
          expect(page).to have_content 'test4'
        end

        within '.details div.expression4' do
          expect(page).to have_content 'test5'
        end
      end

      it 'check if new explanations are on the details page' do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'

        within '.details div.expression2 p.explanation' do
          expect(page).to have_content 'explanation of test3'
        end

        within '.details div.expression3 p.explanation' do
          expect(page).to have_content 'explanation of test4'
        end

        within '.details div.expression4 p.explanation' do
          expect(page).to have_content 'explanation of test5'
        end
      end

      it 'check if new examples of third expression are on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within first('.details div.expression2 p.example') do
          expect(page).to have_content 'test3 example1'
        end

        within all('.details div.expression2 p.example')[1] do
          expect(page).to have_content 'test3 example2'
        end

        within all('.details div.expression2 p.example')[2] do
          expect(page).to have_content 'test3 example3'
        end
      end

      it 'check if new examples of fourth expression are on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within first('.details div.expression3 p.example') do
          expect(page).to have_content 'test4 example1'
        end

        within all('.details div.expression3 p.example')[1] do
          expect(page).to have_content 'test4 example2'
        end

        within all('.details div.expression3 p.example')[2] do
          expect(page).to have_content 'test4 example3'
        end
      end

      it 'check if new examples of fifth expression are on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within first('.details div.expression4 p.example') do
          expect(page).to have_content 'test5 example1'
        end

        within all('.details div.expression4 p.example')[1] do
          expect(page).to have_content 'test5 example2'
        end

        within all('.details div.expression4 p.example')[2] do
          expect(page).to have_content 'test5 example3'
        end
      end

      it 'check if note and new tag are on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within first('.note') do
          expect(page).to have_content 'note'
        end

        within first('.tag') do
          expect(page).to have_content 'tag'
        end
      end
    end

    context 'when tags are edited' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:user2) { FactoryBot.create(:user) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user2.id)) }

      before do
        FactoryBot.create(:tagging, expression: first_expression_items[0].expression)
        FactoryBot.create(:tagging2, expression: second_expression_items[0].expression)
      end

      it 'check if a tag that does not exist in a database is added' do
        sign_in_with_header '/', user
        expect(page).to have_content 'ログインしました'

        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).to have_current_path expression_path(first_expression_items[0].expression)
        click_link '編集'
        3.times { click_button '次へ' }
        fill_in('タグ（任意）', with: 'tag')
        find('#tags').send_keys :return
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(
          Example, :count
        ).by(0).and change(Tag, :count).by(1).and change(Tagging, :count).by(1)
        within '.tag' do
          expect(all('p')[1]).to have_content 'test'
          expect(all('p')[2]).to have_content 'tag'
        end
      end

      it 'check if a tag that exists in a database is added' do
        sign_in_with_header '/', user
        expect(page).to have_content 'ログインしました'

        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).to have_current_path expression_path(first_expression_items[0].expression)
        click_link '編集'
        3.times { click_button '次へ' }
        fill_in('タグ（任意）', with: '2023')
        find('#tags').send_keys :return
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(
          Example, :count
        ).by(0).and change(Tag, :count).by(0).and change(Tagging, :count).by(1)
        within '.tag' do
          expect(all('p')[1]).to have_content 'test'
          expect(all('p')[2]).to have_content '2023'
        end
      end

      it 'check if a tag is changed to a new tag that does not exist in a database' do
        sign_in_with_header '/', user
        expect(page).to have_content 'ログインしました'

        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).to have_current_path expression_path(first_expression_items[0].expression)
        click_link '編集'
        3.times { click_button '次へ' }
        within '.tags' do
          find('i.ti-icon-close').click
        end
        fill_in('タグ（任意）', with: 'tag')
        find('#tags').send_keys :return
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(
          Example, :count
        ).by(0).and change(Tag, :count).by(1).and change(Tagging, :count).by(0)
        within '.tag' do
          expect(all('p')[1]).to have_content 'tag'
        end
      end

      it 'check if a tag is changed to a new tag that exists in a database' do
        sign_in_with_header '/', user
        expect(page).to have_content 'ログインしました'

        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).to have_current_path expression_path(first_expression_items[0].expression)
        click_link '編集'
        3.times { click_button '次へ' }
        within '.tags' do
          find('i.ti-icon-close').click
        end
        fill_in('タグ（任意）', with: '2023')
        find('#tags').send_keys :return
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(
          Example, :count
        ).by(0).and change(Tag, :count).by(0).and change(Tagging, :count).by(0)
        within '.tag' do
          expect(all('p')[1]).to have_content '2023'
        end
      end

      it 'check if a tag is deleted' do
        sign_in_with_header '/', user
        expect(page).to have_content 'ログインしました'

        click_link "#{first_expression_items[0].content} and #{first_expression_items[1].content}"
        expect(page).to have_current_path expression_path(first_expression_items[0].expression)
        click_link '編集'
        3.times { click_button '次へ' }
        within '.tags' do
          find('i.ti-icon-close').click
        end
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(
          Example, :count
        ).by(0).and change(Tag, :count).by(0).and change(Tagging, :count).by(-1)
        expect(page).not_to have_selector '.tag'
      end

      it 'check tags order' do
        sign_in_with_header '/', user2
        expect(page).to have_content 'ログインしました'

        click_link "#{second_expression_items[0].content} and #{second_expression_items[1].content}"
        expect(page).to have_current_path expression_path(second_expression_items[0].expression)
        click_link '編集'
        3.times { click_button '次へ' }
        fill_in('タグ（任意）', with: 'test')
        find('#tags').send_keys :return
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
        within '.tag' do
          expect(all('p')[1]).to have_content '2023'
          expect(all('p')[2]).to have_content 'test'
        end
      end
    end
  end

  describe 'delete expression_items' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:expression) { FactoryBot.create(:empty_note, user_id: user.id) }
    let!(:first_expression_item) { FactoryBot.create(:expression_item, expression:) }
    let!(:second_expression_item) { FactoryBot.create(:expression_item, content: 'balcony', expression:) }
    let!(:third_expression_item) { FactoryBot.create(:expression_item, content: 'veranda', expression:) }

    before do
      FactoryBot.create(:example, expression_item: second_expression_item)
      FactoryBot.create(:example, expression_item: third_expression_item)

      sign_in_with_header '/', user
    end

    it 'check if the third word is deleted' do
      expect(page).to have_content 'ログインしました'
      click_link "#{first_expression_item.content}, balcony and veranda"
      click_link '編集'
      fill_in('英単語 / フレーズ３(任意)', with: '')
      3.times { click_button '次へ' }
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-1).and change(Example, :count).by(-1)
      expect(expression.expression_items.count).to eq 2
      within '.title' do
        expect(page).to have_content "1. #{first_expression_item.content}"
        expect(page).to have_content '2. balcony'
        expect(page).not_to have_content '3. veranda'
      end
    end

    it 'check if the second word is deleted' do
      expect(page).to have_content 'ログインしました'
      click_link "#{first_expression_item.content}, balcony and veranda"
      click_link '編集'
      fill_in('英単語 / フレーズ２', with: '')
      click_button '次へ'
      expect(page).to have_content "#{first_expression_item.content}について"
      click_button '次へ'
      expect(page).not_to have_content 'balconyについて'
      expect(page).to have_content 'verandaについて'
      click_button '次へ'
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-1).and change(Example, :count).by(-1)
      expect(expression.expression_items.count).to eq 2
    end
  end

  describe 'delete examples' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:expression) { FactoryBot.create(:empty_note, user_id: user.id) }
    let!(:first_expression_item) { FactoryBot.create(:expression_item, expression:) }
    let!(:second_expression_item) { FactoryBot.create(:expression_item2, expression:) }

    before do
      FactoryBot.create(:example, expression_item: first_expression_item)

      sign_in_with_header '/', user
    end

    it 'check if the example is deleted' do
      expect(page).to have_content 'ログインしました'
      click_link "#{first_expression_item.content} and #{second_expression_item.content}"
      click_link '編集'
      click_button '次へ'
      fill_in('例文１', with: '')
      2.times { click_button '次へ' }
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(Example, :count).by(-1)
      expect(first_expression_item.examples.count).to eq 0
    end
  end

  describe 'check next and back button' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:expression) { FactoryBot.create(:empty_note, user_id: user.id) }
    let!(:expression_item1) { FactoryBot.create(:expression_item, expression:) }
    let!(:expression_item2) { FactoryBot.create(:expression_item2, expression:) }
    let!(:expression_item3) { FactoryBot.create(:expression_item3, expression:) }
    let!(:expression_item4) { FactoryBot.create(:expression_item4, expression:) }
    let!(:expression_item5) { FactoryBot.create(:expression_item5, expression:) }

    before do
      FactoryBot.create(:example, expression_item: expression_item1)

      sign_in_with_header '/', user
      has_text? 'ログインしました'
      click_link(
        "#{expression_item1.content}, #{expression_item2.content}, #{expression_item3.content}, #{expression_item4.content} and #{expression_item5.content}"
      )
      click_link '編集'
    end

    it 'check buttons' do
      click_button '次へ'
      expect(page).to have_content "#{expression_item1.content}について"
      click_button '戻る'
      expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item2.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item1.content}について"
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item3.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item2.content}について"
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item4.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item3.content}について"
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item5.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item4.content}について"
      2.times { click_button '次へ' }
      expect(page).to have_content 'メモ（任意）'
    end

    it 'check buttons when first word is deleted' do
      fill_in('英単語 / フレーズ１', with: '')
      click_button '次へ'
      expect(page).to have_content "#{expression_item2.content}について"
      click_button '戻る'
      expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item3.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item2.content}について"
      4.times { click_button '次へ' }
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-1).and change(Example, :count).by(-1)
      expect(expression.expression_items.count).to eq 4
      expect(page).to have_content "1. #{expression_item2.content}"
      expect(page).to have_content "2. #{expression_item3.content}"
      expect(page).to have_content "3. #{expression_item4.content}"
      expect(page).to have_content "4. #{expression_item5.content}"
    end

    it 'check buttons when second word is deleted' do
      fill_in('英単語 / フレーズ２', with: '')
      click_button '次へ'
      expect(page).to have_content "#{expression_item1.content}について"
      click_button '次へ'
      expect(page).to have_content "#{expression_item3.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item1.content}について"
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item4.content}について"
      2.times { click_button '次へ' }
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-1).and change(Example, :count).by(0)
      expect(expression.expression_items.count).to eq 4
      expect(page).to have_content "1. #{expression_item1.content}"
      expect(page).to have_content "2. #{expression_item3.content}"
      expect(page).to have_content "3. #{expression_item4.content}"
      expect(page).to have_content "4. #{expression_item5.content}"
    end

    it 'check buttons when third word is deleted' do
      fill_in('英単語 / フレーズ３(任意)', with: '')
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item2.content}について"
      click_button '次へ'
      expect(page).to have_content "#{expression_item4.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item2.content}について"
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item5.content}について"
      click_button '次へ'
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-1).and change(Example, :count).by(0)
      expect(expression.expression_items.count).to eq 4
      expect(page).to have_content "1. #{expression_item1.content}"
      expect(page).to have_content "2. #{expression_item2.content}"
      expect(page).to have_content "3. #{expression_item4.content}"
      expect(page).to have_content "4. #{expression_item5.content}"
    end

    it 'check buttons when fourth word is deleted' do
      fill_in('英単語 / フレーズ４(任意)', with: '')
      3.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item3.content}について"
      click_button '次へ'
      expect(page).to have_content "#{expression_item5.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item3.content}について"
      2.times { click_button '次へ' }
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-1).and change(Example, :count).by(0)
      expect(expression.expression_items.count).to eq 4
      expect(page).to have_content "1. #{expression_item1.content}"
      expect(page).to have_content "2. #{expression_item2.content}"
      expect(page).to have_content "3. #{expression_item3.content}"
      expect(page).to have_content "4. #{expression_item5.content}"
    end

    it 'check buttons when fifth word is deleted' do
      fill_in('英単語 / フレーズ５(任意)', with: '')
      4.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item4.content}について"
      click_button '次へ'
      expect(page).to have_content 'メモ（任意）'
      click_button '戻る'
      expect(page).to have_content "#{expression_item4.content}について"
      click_button '次へ'
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-1).and change(Example, :count).by(0)
      expect(expression.expression_items.count).to eq 4
      expect(page).to have_content "1. #{expression_item1.content}"
      expect(page).to have_content "2. #{expression_item2.content}"
      expect(page).to have_content "3. #{expression_item3.content}"
      expect(page).to have_content "4. #{expression_item4.content}"
    end

    it 'check buttons when second and third words are deleted' do
      fill_in('英単語 / フレーズ２', with: '')
      fill_in('英単語 / フレーズ３(任意)', with: '')
      click_button '次へ'
      expect(page).to have_content "#{expression_item1.content}について"
      click_button '次へ'
      expect(page).to have_content "#{expression_item4.content}について"
      click_button '戻る'
      expect(page).to have_content "#{expression_item1.content}について"
      2.times { click_button '次へ' }
      expect(page).to have_content "#{expression_item5.content}について"
      click_button '次へ'
      expect do
        click_button '編集する'
        expect(page).to have_content '英単語またはフレーズを編集しました'
      end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(-2).and change(Example, :count).by(0)
      expect(expression.expression_items.count).to eq 3
      expect(page).to have_content "1. #{expression_item1.content}"
      expect(page).to have_content "2. #{expression_item4.content}"
      expect(page).to have_content "3. #{expression_item5.content}"
    end
  end
end
