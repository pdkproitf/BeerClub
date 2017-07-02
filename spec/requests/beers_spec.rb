require 'rails_helper'
include Authenticate

RSpec.describe API::Root::BeerApi::Beers, type: :request do

  describe 'POST api/beers' do
    let(:url) { '/api/beers' }
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

  describe 'PUT api/beers/:id' do
    let(:url) { '/api/beers' }
    let!(:beer) { FactoryGirl.create :beer }
    let(:messages) { JSON.parse(response.body) }

    context 'Update a beer' do
      it 'not found' do
        params = { beer: JSON.parse(beer.to_json) }
        put "#{url}/0", params: params, headers: headers

        expect(response).to have_http_status(400)
      end

      it 'update success' do
        params = { beer: JSON.parse(beer.to_json) }
        put "#{url}/#{beer.id}", params: params, headers: headers

        expect(messages['status']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
      end
    end

    context 'Archive beer' do
      it 'error already archived' do
        beer.update_attributes(archived: true)

        put "#{url}/#{beer.id}/archive", params: {}, headers: headers
        expect(response).to have_http_status(500)
        expect(messages['error']).to eq(I18n.t('already_archived', content: "Beer"))
      end

      it 'archived success' do
        put "#{url}/#{beer.id}/archive", params: {}, headers: headers
        expect(messages['status']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
      end
    end

    context 'Unarchive beer' do
      it 'error not archived' do
        put "#{url}/#{beer.id}/unarchive", params: {}, headers: headers
        expect(response).to have_http_status(500)
        expect(messages['error']).to eq(I18n.t('not_archived', content: "Beer"))
      end

      it 'unarchived success' do
        beer.update_attributes(archived: true)

        put "#{url}/#{beer.id}/unarchive", params: {}, headers: headers
        expect(messages['status']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET api/beers/' do
    let(:url) { '/api/beers/' }
    let!(:beer) { FactoryGirl.create :beer }
    let(:messages) { JSON.parse(response.body) }

    context 'get beers' do
      it 'get success' do
        get url

        expect(messages['status']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
      end
    end

    context 'get beer' do
      it 'get success' do
        get "#{url}/#{beer.id}"

        expect(messages['status']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
      end
    end
  end
end
