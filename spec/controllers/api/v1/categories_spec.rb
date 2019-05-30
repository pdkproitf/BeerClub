require 'rails_helper'
include Authenticate

RSpec.describe 'Categories', type: :request do

  let(:body) { JSON.parse(response.body) }
  let!(:category) { FactoryGirl.create :category }
  let(:url) { '/api/v1/categories' }
  let(:params) { sign_user }

  describe 'POST api/v1/categories' do
    let!(:category) { FactoryGirl.build :category }

    context 'Create' do
      it 'wrong credentials' do
        params.merge!(category: { name: nil })
        post url, params: params
        expect(response).to have_http_status(400)
      end

      it 'right credentials' do
        params.merge!(category: FactoryGirl.attributes_for(:category))

        expect { post url, params: params }.to change { Category.count }.from(0).to(1)
        expect(response).to have_http_status(:success)
        expect(Category.last.present?).to eq true
      end
    end
  end

  describe 'PUT api/v1/categories/:id' do
    context 'Update a category' do
      let(:category_update) { FactoryGirl.attributes_for(:category) }

      it 'not found' do
        params.merge!(category: category_update)
        put "#{url}/0", params: params

        expect(response).to have_http_status(400)
      end

      it 'update success' do
        params.merge!(category: category_update)
        put "#{url}/#{category.id}", params: params

        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']['name']).to eq(category_update[:name])

      end
    end

    context 'Archive category' do
      it 'error already archived' do
        category.update_attributes(archived: true)

        put "#{url}/#{category.id}/archive", params: params
        expect(response).to have_http_status(500)
        expect(body['error']).to eq(I18n.t('already_archived', content: "Category"))
      end

      it 'archived success' do
        put "#{url}/#{category.id}/archive", params: params
        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']['archived']).to eq true
      end
    end

    context 'Unarchive category' do
      it 'error not archived' do
        put "#{url}/#{category.id}/unarchive", params: params
        expect(response).to have_http_status(500)
        expect(body['error']).to eq(I18n.t('not_archived', content: "Category"))
      end

      it 'unarchived success' do
        category.update_attributes(archived: true)

        put "#{url}/#{category.id}/unarchive", params: params
        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']['archived']).to eq false
      end
    end
  end

  describe 'GET api/v1/categories/' do
    context 'get categoris' do
      it 'get success' do
        get url

        expect(body['messages']).to eq(I18n.t('success'))
        expect(response).to have_http_status(:success)
        expect(body['data']).to have_at_least(1).items
      end
    end

    context 'get category' do
      it 'get success' do
        get "#{url}/#{category.id}"
        expect(response).to have_http_status(:success)
        expect(body['messages']).to eq(I18n.t('success'))
        expect(body['data']['id']).to eq(category.id)
      end
    end
  end

  describe 'DELETE api/v1/categories/:id' do
    let(:beer) { FactoryGirl.create(:beer, category: category) }

    context 'Delete a category' do
      before do
        beer.update_attributes(category_id: category.id)
      end

      it 'error beer are using' do
        delete "#{url}/#{category.id}", params: params
        expect(response).to have_http_status(406)
        expect(body['error']).to eq(I18n.t('beer_using'))
      end

      it 'delete success' do
        beer.update_attributes(archived: true)

        delete "#{url}/#{category.id}", params: params
        expect(response).to have_http_status(200)
        expect(body['messages']).to eq(I18n.t('success'))
      end
    end
  end
end
