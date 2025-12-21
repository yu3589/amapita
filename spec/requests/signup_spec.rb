require 'rails_helper'

RSpec.describe "POST /auth/google_oauth2/callback", type: :request do
  describe 'Google認証が成功した場合' do
    before do
      # https://github.com/omniauth/omniauth/wiki/Integration-Testing
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      # 認証のパス
      get '/users/auth/google_oauth2/callback', params: { provider: "google_oauth2" }
    end

    it 'Google認証が成功し、HTTPメッセージ302を返すこと' do
      expect(response).to have_http_status(302)
    end
  end

  describe 'Google認証が失敗した場合' do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get '/users/auth/google_oauth2/callback', params: { provider: "google_oauth2" }
    end
      it 'Google認証に失敗し、failureページへリダイレクトされる' do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/users/auth/failure?message=invalid_credentials&strategy=google_oauth2')
    end
  end
end
