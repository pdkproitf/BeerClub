require 'rails_helper'
include Authenticate

RSpec.describe API::Root::UserApi::Sessions, type: :request do

  describe 'POST' do
    let!(:user) { FactoryGirl.create(:user) }
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

      before do
        @user = auto_signin(user)
        @client_id = @user.tokens.first[0]
        @user_param = { uid: @user.uid, client: @client_id, admin_mode: true }
      end

      it 'wrong credentials' do
        @user_param .merge!(access_token: 'wrong access_token')
        post url, params: { user: @user_param }

        expect(response).to have_http_status(404)
        expect(body['error']).to eq(I18n.t('devise_token_auth.sessions.user_not_found'))
      end

      it 'right credentials' do
        @user_param .merge!(access_token: @user.tokens[@client_id]['token'])
        post url, params: { user: @user_param }

        expect(response).to have_http_status(201)
        expect(body['messages']).to eq(I18n.t('devise.sessions.signed_out'))
      end
    end
  end
end
