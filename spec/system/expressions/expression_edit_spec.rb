# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'get the right data to edit' do
    before do
      visit '/expressions/new'
      fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
      fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
      fill_in('３つ目の英単語 / フレーズ', with: 'around the beach')
      fill_in('４つ目の英単語 / フレーズ', with: 'of the beach')
      fill_in('５つ目の英単語 / フレーズ', with: 'in the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
      fill_in('例文１', with: 'example1 of on the beach')
      fill_in('例文２', with: 'example2 of on the beach')
      fill_in('例文３', with: 'example3 of on the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of at the beach')
      fill_in('例文１', with: 'example1 of at the beach')
      fill_in('例文２', with: 'example2 of at the beach')
      fill_in('例文３', with: 'example3 of at the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of around the beach')
      fill_in('例文１', with: 'example1 of around the beach')
      fill_in('例文２', with: 'example2 of around the beach')
      fill_in('例文３', with: 'example3 of around the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of of the beach')
      click_button '次へ'
      fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of in the beach')
      click_button '次へ'
      fill_in('メモ（任意）', with: 'note')
      fill_in('タグ（任意）', with: 'preposition')
      find('input#tags').send_keys :return
      click_button '登録'

      visit '/'
      click_link 'on the beach'
      click_link '編集'
    end

    it 'check if data of expression_items content is on the first page' do
      expect(page).to have_field('１つ目の英単語 / フレーズ', with: 'on the beach')
      expect(page).to have_field('２つ目の英単語 / フレーズ', with: 'at the beach')
      expect(page).to have_field('３つ目の英単語 / フレーズ', with: 'around the beach')
      expect(page).to have_field('４つ目の英単語 / フレーズ', with: 'of the beach')
      expect(page).to have_field('５つ目の英単語 / フレーズ', with: 'in the beach')
    end

    it 'check if explanation and examples are on the second page' do
      click_button '次へ'
      expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。',
                                 with: 'explanation of on the beach')
      expect(page).to have_field('例文１', with: 'example1 of on the beach')
      expect(page).to have_field('例文２', with: 'example2 of on the beach')
      expect(page).to have_field('例文３', with: 'example3 of on the beach')
    end

    it 'check if explanation and examples are on the third page' do
      2.times { click_button '次へ' }

      expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of at the beach')
      expect(page).to have_field('例文１', with: 'example1 of at the beach')
      expect(page).to have_field('例文２', with: 'example2 of at the beach')
      expect(page).to have_field('例文３', with: 'example3 of at the beach')
    end

    it 'check if explanation and examples are on the fourth page' do
      3.times { click_button '次へ' }

      expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of around the beach')
      expect(page).to have_field('例文１', with: 'example1 of around the beach')
      expect(page).to have_field('例文２', with: 'example2 of around the beach')
      expect(page).to have_field('例文３', with: 'example3 of around the beach')
    end

    it 'check if data of explanation is on the fifth page' do
      4.times { click_button '次へ' }

      expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of of the beach')
    end

    it 'check if data of explanation is on the sixth page' do
      5.times { click_button '次へ' }

      expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of in the beach')
    end

    it 'check if date of note and the tag are on the last page' do
      6.times { click_button '次へ' }

      expect(page).to have_field('メモ（任意）', with: 'note')
      within 'li.tags' do
        expect(page).to have_content 'preposition'
      end
    end
  end

  describe 'edit expressions' do
    context 'when first expression is edited and example is added' do
      before do
        visit '/expressions/1'
        click_link '編集'
        fill_in('１つ目の英単語 / フレーズ', with: 'journey')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'Travelling but this word means more broad.')
        fill_in('例文１', with: 'The journey was tiring.')
        2.times { click_button '次へ' }
      end

      it 'check if database does not create data when editing' do
        expect do
          click_button '編集する'
          expect(page).to have_content '英単語またはフレーズを編集しました'
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(Example, :count).by(1)
      end

      it 'check if the word which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.title div' do
          expect(page).to have_content 'journey'
          expect(page).not_to have_content 'balcony'
        end

        within '.details' do
          expect(page).to have_content(/^journey$/)
        end
      end

      it 'check if the explanation which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details' do
          expect(page).to have_content 'Travelling but this word means more broad.'
          expect(page).not_to have_content 'A platform on the side of a building, accessible from inside the building.'
        end
      end

      it 'check if the example is on the details page' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.details' do
          expect(page).to have_content 'The journey was tiring.'
        end
      end
    end

    context 'when second word is edited and examples are added' do
      before do
        visit '/expressions/1'
        click_link '編集'
        fill_in('２つ目の英単語 / フレーズ', with: 'veranda')
        2.times { click_button '次へ' }
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。',
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
        end.to change(Expression, :count).by(0).and change(ExpressionItem, :count).by(0).and change(Example, :count).by(3)
      end

      it 'check if the word which already saved change to another one' do
        click_button '編集する'
        has_text? '英単語またはフレーズを編集しました'

        within '.title div' do
          expect(page).to have_content 'veranda'
          expect(page).not_to have_content 'Veranda'
        end

        within '.details div.expression1' do
          expect(page).to have_content 'veranda'
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
      before do
        visit '/expressions/new'
        fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
        fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
        fill_in('３つ目の英単語 / フレーズ', with: 'around the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of at the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of around the beach')
        fill_in('例文１', with: 'example1 of around the beach')
        fill_in('例文２', with: 'example2 of around the beach')
        fill_in('例文３', with: 'example3 of around the beach')
        click_button '次へ'
        fill_in('メモ（任意）', with: 'note')
        click_button '登録'

        visit '/'
        click_link 'on the beach'
        click_link '編集'
        fill_in('３つ目の英単語 / フレーズ', with: 'test3')
        3.times { click_button '次へ' }
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of test3')
        fill_in('例文１', with: 'example1 of around the beach test1')
        fill_in('例文２', with: 'test2')
        fill_in('例文３', with: 'test3')
        click_button '次へ'
        fill_in('メモ（任意）', with: 'note. note is added.')
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
          expect(page).to have_content 'test3'
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
          expect(page).to have_content 'example1 of around the beach test1'
        end

        within all('.details div.expression2 p.example')[1] do
          expect(page).to have_content 'test2'
        end

        within all('.details div.expression2 p.example')[2] do
          expect(page).to have_content 'test3'
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
      before do
        visit '/expressions/1'
        click_link '編集'
        fill_in('３つ目の英単語 / フレーズ', with: 'test3')
        fill_in('４つ目の英単語 / フレーズ', with: 'test4')
        fill_in('５つ目の英単語 / フレーズ', with: 'test5')
        3.times { click_button '次へ' }
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of test3')
        fill_in('例文１', with: 'test3 example1')
        fill_in('例文２', with: 'test3 example2')
        fill_in('例文３', with: 'test3 example3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of test4')
        fill_in('例文１', with: 'test4 example1')
        fill_in('例文２', with: 'test4 example2')
        fill_in('例文３', with: 'test4 example3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of test5')
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
        has_text? '英単語またはフレーズを編集しました'

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
  end
end
