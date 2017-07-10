require 'rails_helper'
include Authenticate

RSpec.describe 'Sessions', type: :request do

  describe 'POST' do
    let(:user) { FactoryGirl.create(:user) }
    let(:body) { JSON.parse(response.body) }

    context 'sign-in' do
      let(:url) { '/api/v2/users/sign-in' }

      it 'wrong credentials' do
        params = { user: { email: user.email, password: 'wrong_password', admin_mode: true } }
        post url, params: params

        expect(response).to have_http_status(500)
        expect(body['error']).to eq(I18n.t('devise_token_auth.sessions.bad_credentials'))
      end

      it 'right credentials' do
        params = { user: { email: user.email, password: user.password, admin_mode: true } }
        post url, params: params
        expect(response).to have_http_status(201)
        expect(body['messages']).to eq(I18n.t('devise.sessions.signed_in'))
      end
    end

    context 'sign-out' do
      let(:url) { '/api/v2/users/sign-out' }
      let(:params) { { user: sign_user } }

      it 'wrong credentials' do
        params[:user].merge!(uid: 'wrong uid')
        params[:user].merge!(access_token: 'wrong Access token')
        post url, params: params

        expect(response).to have_http_status(404)
        expect(body['error']).to eq(I18n.t('devise_token_auth.sessions.user_not_found'))
      end

      it 'right credentials' do
        params[:user].merge!(uid: @user.email)
        params[:user].merge!(access_token: params[:user][:token])
        post url, params: params

        expect(response).to have_http_status(201)
        expect(body['messages']).to eq(I18n.t('devise.sessions.signed_out'))
      end
    end
  end
end
