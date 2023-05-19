# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expressions' do
  describe 'create expressions' do
    before do
      FactoryBot.create(:tag)
    end

    describe 'authority' do
      it 'check if error message is shown when user has not logged in' do
        visit '/'
        click_link '新規作成'
        expect(page).to have_current_path root_path
        within '.unauthorized_access_to_create' do
          expect(page).to have_content 'ログインが必要です'
          expect(page).to have_button 'Sign up/Log in with Google'
        end
        expect(find('.error', visible: false)).not_to be_visible
      end

      it 'check if the form is not shown when user has not logged in' do
        visit '/expressions/new'
        expect(page).to have_current_path root_path
        within '.unauthorized_access_to_create' do
          expect(page).to have_content 'ログインが必要です'
          expect(page).to have_button 'Sign up/Log in with Google'
        end
        expect(find('.error', visible: false)).not_to be_visible
      end
    end

    describe 'redirect' do
      let!(:user) { FactoryBot.create(:user) }
      let(:new_user) { FactoryBot.build(:user) }

      it 'check if a form is on the page when user logged in' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_link '新規作成'
        expect(page).to have_content 'ログインが必要です'
        within '.unauthorized_access_to_create' do
          click_button 'Sign up/Log in with Google'
        end
        expect(page).to have_current_path '/expressions/new'
        expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
      end

      it 'check if a form is on the page when new user logged in' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: new_user.uid, info: { name: new_user.name } })

        visit '/'
        click_link '新規作成'
        expect(page).to have_content 'ログインが必要です'
        within '.unauthorized_access_to_create' do
          click_button 'Sign up/Log in with Google'
        end
        expect(page).to have_current_path '/expressions/new'
        expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
      end

      it 'check if a form is on the page when user logged in from login button on header' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_link '新規作成'
        expect(page).to have_content 'ログインが必要です'
        within '.button-on-header' do
          click_button 'Sign up/Log in with Google'
        end
        expect(page).to have_current_path '/expressions/new'
        expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
      end

      it 'check if there is not infinite loop when user click 新規作成 button more than once' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        3.times do
          click_link '新規作成'
          expect(page).to have_content 'ログインが必要です'
          expect(page).to have_current_path root_path
        end

        within '.button-on-header' do
          click_button 'Sign up/Log in with Google'
        end
        expect(page).to have_current_path '/expressions/new'
      end
    end

    context 'when two phrases, the explanations, one example for each, the note and one tag are given' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
        click_link '新規作成'

        fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
        fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
        fill_in('例文１', with: 'example of on the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of at the beach')
        fill_in('例文２', with: 'example of at the beach')
        click_button '次へ'
        fill_in('メモ（任意）', with: 'note')
        fill_in('タグ（任意）', with: 'preposition')
        find('input#tags').send_keys :return
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(2).and change(Example, :count).by(2).and change(Tag, :count).by(1)
      end
    end

    context 'when three words, the explanations, one example for one word and tags without the note are given' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
        visit '/expressions/new'

        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        fill_in('例文１', with: 'example of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('タグ（任意）', with: 'test')
        find('input#tags').send_keys :return
        fill_in('タグ（任意）', with: 'noun')
        find('input#tags').send_keys :return
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(3).and change(Example, :count).by(1).and change(Tag, :count).by(1)
      end
    end

    context 'when four words, the explanations, two examples for each and tags without the note are given' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
        click_link '新規作成'

        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        fill_in('例文１', with: 'first example of word1')
        fill_in('例文２', with: 'second example of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        fill_in('例文１', with: 'first example of word2')
        fill_in('例文２', with: 'second example of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        fill_in('例文１', with: 'first example of word3')
        fill_in('例文２', with: 'second example of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        fill_in('例文１', with: 'first example of word4')
        fill_in('例文２', with: 'second example of word4')
        click_button '次へ'
        fill_in('タグ（任意）', with: 'test')
        find('input#tags').send_keys :return
        fill_in('タグ（任意）', with: '2023')
        find('input#tags').send_keys :return
        fill_in('タグ（任意）', with: '動詞')
        find('input#tags').send_keys :return
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(4).and change(Example, :count).by(8).and change(Tag, :count).by(2)
      end
    end

    context 'when five words, the explanations, three example for two words and one tag without the note are given' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

        visit '/'
        click_button 'Sign up/Log in with Google'
        click_link '新規作成'

        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        fill_in('５つ目の英単語 / フレーズ', with: 'word5')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        fill_in('例文１', with: 'first example of word4')
        fill_in('例文２', with: 'second example of word4')
        fill_in('例文３', with: 'third example of word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word5')
        fill_in('例文１', with: 'first example of word5')
        fill_in('例文２', with: 'second example of word5')
        fill_in('例文３', with: 'third example of word5')
        click_button '次へ'
        fill_in('タグ（任意）', with: '名詞')
        find('input#tags').send_keys :return
      end

      it 'create data' do
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Expression, :count).by(1).and change(ExpressionItem, :count).by(5).and change(Example, :count).by(6).and change(Tag, :count).by(1)
      end
    end
  end

  describe 'validation error' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      click_link '新規作成'
    end

    describe 'words and phrases' do
      it 'show validation error if only one word is given' do
        fill_in('１つ目の英単語 / フレーズ', with: 'word')
        click_button '次へ'
        expect(page).to have_css '.text-red-600'
        expect(page).to have_content '英単語又はフレーズを２つ以上入力してください'
        expect(page).not_to have_content '{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。'
      end

      it 'show validation error if no words are given' do
        expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
        click_button '次へ'
        expect(page).to have_content '英単語又はフレーズを２つ以上入力してください'
        expect(page).not_to have_content '{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。'
      end

      it 'go to next page once users input more than two expressions after validation error' do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        click_button '次へ'
        expect(page).to have_content '英単語又はフレーズを２つ以上入力してください'
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        click_button '次へ'
        expect(page).not_to have_content '英単語又はフレーズを２つ以上入力してください'
        expect(page).to have_content '{word}について'
      end
    end

    describe 'explanations' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
        fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
        click_button '次へ'
      end

      it 'show validation error if the explanation is not given' do
        expect(page).to have_content '{word}について'
        expect(page).not_to have_css '.text-red-600'
        click_button '次へ'
        expect(page).to have_css '.text-red-600'
      end

      it 'go to the next page once users input the explanation after validation error on the second page' do
        click_button '次へ'
        expect(page).to have_css '.text-red-600'

        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
        click_button '次へ'
        expect(page).not_to have_css '.text-red-600'
      end

      it 'go to the next page once users input the explanation after validation error on the third page' do
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
        click_button '次へ'
        click_button '次へ'
        expect(page).to have_css '.text-red-600'

        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of at the beach')
        click_button '次へ'
        expect(page).not_to have_css '.text-red-600'
        expect(page).to have_content 'メモ（任意）'
      end
    end

    describe 'examples' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
      end

      it 'no validation error when examples are not given' do
        expect(page).to have_content '{word}について'
        expect(page).not_to have_css '.text-red-600'
      end
    end

    describe 'tags' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('タグ（任意）', with: 'English')
        find('input#tags').send_keys :return
        fill_in('タグ（任意）', with: '2023')
        find('input#tags').send_keys :return
        fill_in('タグ（任意）', with: '漢字')
        find('input#tags').send_keys :return
        fill_in('タグ（任意）', with: 'ひらがな')
        find('input#tags').send_keys :return
        fill_in('タグ（任意）', with: 'カタカナ')
        find('input#tags').send_keys :return
      end

      it 'avoid adding duplicate in English' do
        fill_in('タグ（任意）', with: 'English')
        find('input#tags').send_keys :return
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Tag, :count).by(5)
      end

      it 'avoid adding duplicate number' do
        fill_in('タグ（任意）', with: '2023')
        find('input#tags').send_keys :return
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Tag, :count).by(5)
      end

      it 'avoid adding duplicate in Kanji' do
        fill_in('タグ（任意）', with: '漢字')
        find('input#tags').send_keys :return
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Tag, :count).by(5)
      end

      it 'avoid adding duplicate in Hiragana' do
        fill_in('タグ（任意）', with: 'ひらがな')
        find('input#tags').send_keys :return
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Tag, :count).by(5)
      end

      it 'avoid adding duplicate in Katakana' do
        fill_in('タグ（任意）', with: 'カタカナ')
        find('input#tags').send_keys :return
        expect do
          click_button '登録'
          expect(page).to have_content '英単語またはフレーズを新規作成しました'
        end.to change(Tag, :count).by(5)
      end
    end

    describe 'applicable scope' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'on the beach')
        fill_in('２つ目の英単語 / フレーズ', with: 'at the beach')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of on the beach')
        click_button '次へ'
      end

      it 'check if previous page does not have validation error after clicking a back button on the page that has validation error' do
        expect(page).not_to have_css '.text-red-600'
        click_button '次へ'
        expect(page).to have_css '.text-red-600'
        click_button '戻る'
        expect(page).not_to have_css '.text-red-600'
      end
    end
  end

  describe 'the back button on the last page' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      click_link '新規作成'
    end

    context 'when two expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
      end
    end

    context 'when three expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
      end
    end

    context 'when four expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
      end
    end

    context 'when five expressions are given' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        fill_in('５つ目の英単語 / フレーズ', with: 'word5')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word5')
        click_button '次へ'
      end

      it 'check if the page goes back to right one after clicking the back button' do
        expect(page).to have_content 'メモ（任意）'
        click_button '戻る'
        expect(page).to have_field('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word5')
      end
    end
  end

  describe 'step navigation' do
    let(:user) { FactoryBot.build(:user) }

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

      visit '/'
      click_button 'Sign up/Log in with Google'
      click_link '新規作成'
    end

    describe 'on the first page' do
      it 'check step1' do
        within('.bg-yellow-200') do
          expect(page).to have_css '.fa-pen-to-square'
          expect(page).to have_content 'Step1'
        end
      end

      it 'check step2' do
        within first(:css, '.text-gray-400') do
          expect(page).to have_css '.fa-pen-to-square'
          expect(page).to have_content 'Step2'
        end
      end

      it 'check step3' do
        within all('.text-gray-400').last do
          expect(page).to have_css '.fa-pen-to-square'
          expect(page).to have_content 'Step3'
        end
      end
    end

    context 'when two expressions are input without clicking any back buttons' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        click_button '次へ'
      end

      it 'show check circle after completing the step1' do
        within first(:css, '.border-gray-300') do
          expect(page).to have_css '.fa-circle-check'
          expect(page).to have_css '.text-yellow-400'
        end

        within('.bg-yellow-200') { expect(page).to have_content 'Step2' }
      end

      it 'show the check circle after completing the step2' do
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'

        expect(all('.fa-circle-check').length).to eq 2
        within('.bg-yellow-200') { expect(page).to have_content 'Step3' }
      end
    end

    context 'when three expressions are input with clicking back buttons' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
      end

      it 'show the check circle after completing the step2' do
        within('.bg-yellow-200') { expect(page).to have_content 'Step2' }

        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'

        expect(all('.fa-circle-check').length).to eq 2
      end

      it 'check background color when the page is on the note and tags' do
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'

        expect(page).to have_content 'メモ（任意）'
        within('.bg-yellow-200') { expect(page).to have_content 'Step3' }
      end

      it 'check step1 icon after completing the step1 and then go back to the step from step2' do
        expect(all('.text-yellow-400').length).to eq 1
        click_button '戻る'
        click_button '戻る'
        click_button '戻る'
        expect(page).to have_content '意味の違いや使い分けを学習したい英単語又はフレーズを入力してください'
        within('.bg-yellow-200') { expect(page).to have_css '.fa-circle-check' }
      end

      it 'check step2 icon after completing the step2 and then go back to the step from step3' do
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        click_button '戻る'
        expect(page).to have_content '{word}について'
        within('.bg-yellow-200') do
          expect(page).to have_css '.fa-circle-check'
          expect(page).to have_content 'Step2'
        end
      end

      it 'check step1 icon after completing the step2 and then go back to the step from step3' do
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        click_button '戻る'
        within first(:css, '.border-gray-300') do
          expect(page).to have_css '.fa-circle-check'
          expect(page).to have_css '.text-yellow-400'
        end
      end
    end

    context 'when expressions amount change four from three after completing step2' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        click_button '戻る'
        click_button '戻る'
        click_button '戻る'
        click_button '戻る'
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        click_button '次へ'
      end

      it 'check step2 icon if it changes' do
        within('.bg-yellow-200') do
          expect(page).to have_css '.fa-pen-to-square'
          expect(page).to have_content 'Step2'
        end
      end
    end

    context 'when expressions amount change four from five after completing step2' do
      before do
        fill_in('１つ目の英単語 / フレーズ', with: 'word1')
        fill_in('２つ目の英単語 / フレーズ', with: 'word2')
        fill_in('３つ目の英単語 / フレーズ', with: 'word3')
        fill_in('４つ目の英単語 / フレーズ', with: 'word4')
        fill_in('５つ目の英単語 / フレーズ', with: 'word5')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word1')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word2')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word3')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word4')
        click_button '次へ'
        fill_in('{word}の意味や前ページで登録した英単語 / フレーズ（{comparison}）との違いを入力してください。', with: 'explanation of word5')
        click_button '次へ'
        click_button '戻る'
        click_button '戻る'
        click_button '戻る'
        click_button '戻る'
        click_button '戻る'
        click_button '戻る'
        fill_in('５つ目の英単語 / フレーズ', with: '')
        click_button '次へ'
      end

      it 'check step2 icon if it changes' do
        within('.bg-yellow-200') do
          expect(page).to have_css '.fa-pen-to-square'
          expect(page).to have_content 'Step2'
        end
      end
    end
  end
end
