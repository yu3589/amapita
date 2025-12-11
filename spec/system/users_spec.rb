require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'ユーザー新規登録' do
    context 'フォームの入力値が正常' do
      it 'ユーザーの新規作成が成功する' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: 'test_user'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button 'アカウント作成'
        expect(page).to have_content 'アカウント登録が完了しました。'
        expect(current_path).to eq posts_path
      end
    end

    context '登録済みのメールアドレスを入力' do
      it 'ユーザーの新規作成が失敗する' do
        existed_user = create(:user)
        visit new_user_registration_path
        fill_in 'ユーザー名', with:  existed_user.name
        fill_in 'メールアドレス', with: existed_user.email
        fill_in 'パスワード', with: existed_user.password
        fill_in 'パスワード（確認用）', with: existed_user.password_confirmation
        click_button 'アカウント作成'
        expect(page).to have_content 'メールアドレスが登録できませんでした。'
      end
    end

    context 'メールアドレスが未入力' do
      it 'ユーザーの新規作成が失敗する' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: 'test_user'
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button 'アカウント作成'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context 'ユーザー名が未入力' do
      it 'ユーザーの新規作成が失敗する' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button 'アカウント作成'
        expect(page).to have_content 'ユーザー名を入力してください'
      end
    end

    context 'パスワードが未入力' do
      it 'ユーザーの新規作成が失敗する' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: 'test_user'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認用）', with: 'password'
        click_button 'アカウント作成'
        expect(page).to have_content 'パスワードを入力してください'
      end
    end

    context 'パスワード確認が一致しない' do
      it 'ユーザーの新規作成が失敗する' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: 'test_user'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password123'
        click_button 'アカウント作成'
        expect(page).to have_content 'パスワード（確認用）と一致しません'
      end
    end
  end

  let(:user) { create(:user) }
  describe 'ユーザー編集' do
    context 'ユーザー名が未入力' do
      it 'ユーザーの編集が失敗する' do
        login(user)
        visit edit_profile_path
        fill_in 'ユーザー名', with: ''
        click_button '更新する'
        expect(page).to have_content 'ユーザー名を入力してください'
      end
    end
  end
end
