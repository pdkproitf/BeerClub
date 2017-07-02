require 'rails_helper'

RSpec.describe API::Root::UserApi::Sessions, type: :request do

  describe 'POST api/users/sign-in' do
    let(:url) { '/api/users/sign-in' }
    let!(:user) { FactoryGirl.create(:user) }
    let(:messages) { JSON.parse(response.body) }

    context 'sign-in' do
      it 'wrong credentials' do
        params = { user: { email: user.email, password: 'wrong_password', admin_mode: true } }
        post url, params: params

        expect(response).to have_http_status(500)
        expect(messages['error']).to eq(I18n.t('devise_token_auth.sessions.bad_credentials'))
      end

      it 'right credentials' do
        params = { user: { email: user.email, password: user.password, admin_mode: true } }
        post url, params: params

        expect(response).to have_http_status(201)
        expect(messages['status']).to eq(I18n.t('devise.sessions.signed_in'))
      end
    end
  end
end
