require 'rails_helper'
include Authenticate

RSpec.describe 'Passports', type: :request do
  let(:url) { '/api/v1/passports/' }
  let!(:passport) { FactoryGirl.create(:passport) }
  let(:body) { JSON.parse(response.body) }
  let(:params) { sign_user }

  describe 'GET' do
    context 'get passport inform' do
      context 'success' do
        it "with admin role" do
          get "#{url}/#{passport.id}", params: params

          expect(response).to have_http_status(:success)
          expect(body['messages']).to eq(I18n.t('success'))
          expect(body['data']['id']).to(eq passport.id)
          expect(body['data']['name']).to(eq passport.name)
        end

        it "with customer role" do
          params = sign_customer
          passport = @user.passport
          get "#{url}/#{passport.id}", params: params

          expect(response).to have_http_status(:success)
          expect(body['messages']).to eq(I18n.t('success'))
          expect(body['data']['id']).to(eq passport.id)
          expect(body['data']['name']).to(eq passport.name)
        end
      end

      it "error without role" do
        params = { token: '', client: '' }
        get "#{url}/#{passport.id}", params: params

        expect(response).to have_http_status(:unauthorized)
        expect(body['error']).to eq(I18n.t('Unauthor'))
      end
    end

    context 'get passports' do
      it "success with admin role" do
        get url, params: params

        expect(response).to have_http_status(:success)
        expect(body['messages']).to eq(I18n.t('success'))
      end

      it "error without role" do
        get url

        expect(response).to have_http_status(:unauthorized)
        expect(body['error']).to eq(I18n.t('Unauthor'))
      end
    end
  end

  describe 'manage beer on passport' do
    let(:url) { '/api/v1/passports/beer' }
    let!(:beer) { FactoryGirl.create(:beer) }

    before do
      params.merge!(passport_id: passport.id)
      params.merge!(beer_id: beer.id)
    end

    context 'add beer to passport' do
      it 'success' do
        post url, params: params

        expect(response).to have_http_status(:success)
        expect(body['messages']).to eq(I18n.t('success'))
        expect(passport.beers.last.id).to eq beer.id
      end

      it 'beer already exist' do
        passport.passport_beers.create(beer_id: beer.id)
        post url, params: params
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'remove beer from passport' do
      it "success" do
        passport.passport_beers.create(beer_id: beer.id)
        delete url, params: params
        expect(response).to have_http_status(:success)
      end

      it "error not found beer on passport" do
        delete url, params: params

        expect(response).to have_http_status(:not_found)
        expect(body['error']).to eq(I18n.t('not_found', title: 'Beer on Passport'))
      end
    end
  end
end
