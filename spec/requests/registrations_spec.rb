require 'rails_helper'

RSpec.describe API::Root::UserApi::Registrations, type: :request do

  describe 'POST api/users' do
    let(:url) { '/api/users' }
    let(:user) { FactoryGirl.attributes_for :user }

    context 'Create' do
      it 'create a admin account' do
        @headers = headers # create a user in this to authenticate when create a admin account
        user.merge!(admin_mode: true)
        params = { user: user }

        expect { post url, params: params, headers: @headers }.to change { User.count }.from(1).to(2)
        expect(response).to have_http_status(:success)
        expect(User.last.admin?).to be true
        expect(User.last.present?).to be true
      end

      it 'create customer' do
        user.merge!(admin_mode: false)
        params = { user: user }

        expect { post url, params: params }.to change { Customer.count }.from(0).to(1)
        expect(response).to have_http_status(:success)
        expect(Customer.last.present?).to be true
      end
    end
  end
end
