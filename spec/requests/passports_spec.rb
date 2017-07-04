require 'rails_helper'
include Authenticate

RSpec.describe API::Root::PassportApi::Passports, type: :request do
  let(:url) { '/api/v1/passports/' }
  let!(:passport) { FactoryGirl.create(:passport) }
  let(:body) { JSON.parse(response.body) }

  describe 'GET' do
    it 'get passport inform' do
        get "#{url}/#{passport.id}", headers: headers

        expect(response).to have_http_status(:success)
        expect(body['messages']).to eq(I18n.t('success'))
        expect(body['data']['id']).to(eq passport.id)
        expect(body['data']['name']).to(eq passport.name)
    end

    it 'get passports' do
        get url, headers: headers

        expect(response).to have_http_status(:success)
        expect(body['messages']).to eq(I18n.t('success'))
    end
  end

  describe 'manage beer on passport' do
    let(:url) { '/api/v1/passports/beer' }
    let!(:beer) { FactoryGirl.create(:beer) }

    describe 'add beer to passport' do
      it 'success' do
        post url, params: { passport_id: passport.id, beer_id: beer.id }, headers: headers

        expect(response).to have_http_status(:success)
        expect(body['messages']).to eq(I18n.t('success'))
        expect(passport.beers.last.id).to eq beer.id
      end

      it 'beer already exist' do
        passport.passport_beers.create(beer_id: beer.id)
        post url, params: { passport_id: passport.id, beer_id: beer.id }, headers: headers
        expect(response).to have_http_status(:bad_request)
      end
    end

    it 'remove beer from passport' do
      passport.passport_beers.create(beer_id: beer.id)
      delete url, params: { passport_id: passport.id, beer_id: beer.id }, headers: headers

      expect(response).to have_http_status(:success)
      expect(body['messages']).to eq(I18n.t('success'))
    end
  end
end
