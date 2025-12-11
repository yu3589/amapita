require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }
  before do
    driven_by(:rack_test)
  end

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログインが成功する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました。'
        expect(current_path).to eq posts_path
      end
    end

    context 'メールアドレスが未入力' do
      it 'ログインが失敗する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end

    context 'パスワードが未入力' do
      it 'ログインが失敗する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end

    context '登録されていないメールアドレスを入力' do
      it 'ログインが失敗する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: 'unknown@example.com'
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end

    context 'パスワードが間違っている' do
      it 'ログインが失敗する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe 'ログアウト' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウトが成功する' do
        login(user)
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました。'
        expect(current_path).to eq root_path
      end
    end
  end
end
