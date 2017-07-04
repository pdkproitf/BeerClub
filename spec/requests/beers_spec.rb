require 'rails_helper'
include Authenticate

RSpec.describe API::Root::BeerApi::Beers, type: :request do

  let(:url) { '/api/v1/beers' }
  let!(:beer) { FactoryGirl.create :beer }
  let(:body) { JSON.parse(response.body) }

  describe 'POST api/v1/beers' do
    let!(:beer) { FactoryGirl.build :beer }

    context 'Create' do
      it 'wrong credentials' do
        params = { beer: (beer.to_json) }
        post url, params: params, headers: headers
        expect(response).to have_http_status(400)
      end

      it 'right credentials' do
        params = { beer: JSON.parse(beer.to_json) }
        expect { post url, params: params, headers: headers }.to change { Beer.count }.from(0).to(1)
        expect(response).to have_http_status(:success)
        expect(Beer.last.present?).to eq true
      end
    end
  end

  describe 'PUT api/v1/beers/:id' do
    context 'Update a beer' do
      it 'not found' do
        params = { beer: JSON.parse(beer.to_json) }
        put "#{url}/0", params: params, headers: headers

        expect(response).to have_http_status(400)
      end

      it 'update success' do
        new_name = Faker::Name.name
        beer.name = new_name
        params = { beer: JSON.parse(beer.to_json) }
        put "#{url}/#{beer.id}", params: params, headers: headers

        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']['name']).to eq(new_name)
      end
    end

    context 'Archive beer' do
      it 'error already archived' do
        beer.update_attributes(archived: true)

        put "#{url}/#{beer.id}/archive", params: {}, headers: headers
        expect(response).to have_http_status(500)
        expect(body['error']).to eq(I18n.t('already_archived', content: "Beer"))
      end

      it 'archived success' do
        put "#{url}/#{beer.id}/archive", params: {}, headers: headers
        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']['archived']).to eq true
      end
    end

    context 'Unarchive beer' do
      it 'error not archived' do
        put "#{url}/#{beer.id}/unarchive", params: {}, headers: headers
        expect(response).to have_http_status(500)
        expect(body['error']).to eq(I18n.t('not_archived', content: "Beer"))
      end

      it 'unarchived success' do
        beer.update_attributes(archived: true)

        put "#{url}/#{beer.id}/unarchive", params: {}, headers: headers
        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']['archived']).to eq false
      end
    end
  end

  describe 'GET api/v1/beers/' do
    context 'get beers' do
      it 'get success' do
        get url

        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']).to have_at_least(1).items
      end
    end

    context 'get beer' do
      it 'get success' do
        get "#{url}/#{beer.id}"

        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']['name']).to eq beer.name
        expect(body['data']['manufacurter']).to eq beer.manufacurter
        expect(body['data']['country']).to eq beer.country
        expect(body['data']['price']).to eq beer.price
      end
    end
  end
end
