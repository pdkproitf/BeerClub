require 'rails_helper'
include Authenticate

RSpec.describe 'Sessions', type: :request do

  describe 'POST' do
    let(:user) { FactoryGirl.create(:user, role: Role.find_or_create_by(name: 'Admin')) }
    let(:body) { JSON.parse(response.body) }

    context 'sign-in' do
      let(:url) { '/api/v1/users/sign-in' }

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
      let(:url) { '/api/v1/users/sign-out' }
      let(:params) { { user: sign_user } }

      before do
        params[:user].merge!(uid: @user.email)
        params[:user].merge!(admin_mode: true)
      end

      it 'wrong credentials' do
        params[:user].merge!(access_token: 'wrong Access token')
        post url, params: params

        expect(response).to have_http_status(404)
        expect(body['error']).to eq(I18n.t('devise_token_auth.sessions.user_not_found'))
      end

      it 'right credentials' do
        params[:user].merge!(access_token: @user.tokens[params[:user][:client]]["token"])
        post url, params: params

        expect(response).to have_http_status(201)
        expect(body['messages']).to eq(I18n.t('devise.sessions.signed_out'))
      end
    end
  end
end
