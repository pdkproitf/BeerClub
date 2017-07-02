require 'rails_helper'
include Authenticate

RSpec.describe API::Root::PassportApi::Passports, type: :request do

  describe 'GET api/passports/' do
    let(:url) { '/api/passports/' }
    let!(:passport) { FactoryGirl.create(:passport) }
    let(:messages) { JSON.parse(response.body) }

    it 'get a passport inform' do
        get "#{url}/#{passport.id}", headers: headers

        expect(response).to have_http_status(:success)
        expect(messages['status']).to eq(I18n.t('success'))
        expect(messages['data']['id']).to(eq passport.id)
        expect(messages['data']['name']).to(eq passport.name)
    end

    it 'get a passports' do
        get url, headers: headers

        expect(response).to have_http_status(:success)
        expect(messages['status']).to eq(I18n.t('success'))
    end
  end

  describe 'POST api/passports/' do
    let(:url) { '/api/passports/beer' }
    let!(:passport) { FactoryGirl.create(:passport) }
    let!(:beer) { FactoryGirl.create(:beer) }
    let(:messages) { JSON.parse(response.body) }

    context 'add beer to passport' do
      it 'success' do
        post url, params: { passport_id: passport.id, beer_id: beer.id } ,headers: headers

        expect(response).to have_http_status(:success)
        expect(messages['status']).to eq(I18n.t('success'))
      end

      it 'beer already exist' do
        passport.passport_beers.create(beer_id: beer.id)
        post url, params: { passport_id: passport.id, beer_id: beer.id } ,headers: headers
        expect(response).to have_http_status(:bad_request)
      end
    end

  end

  describe 'DELETE api/passports/' do
    let(:url) { '/api/passports/beer' }
    let!(:passport) { FactoryGirl.create(:passport) }
    let!(:beer) { FactoryGirl.create(:beer) }
    let(:messages) { JSON.parse(response.body) }

    it 'remove beer from passport' do
        passport.passport_beers.create(beer_id: beer.id)
        delete url, params: { passport_id: passport.id, beer_id: beer.id } ,headers: headers

        expect(response).to have_http_status(:success)
        expect(messages['status']).to eq(I18n.t('success'))
    end
  end
end
