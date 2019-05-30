require 'rails_helper'

RSpec.describe 'Registrations', type: :request do

  describe 'POST api/v2/users' do
    let(:url) { '/api/v2/users' }
    let(:user) { FactoryGirl.attributes_for :user }
    let(:params) { sign_user }

    context 'Create' do
      it 'create a admin account' do
        user.merge!(admin_mode: true)
        params.merge!(user: user )

        expect { post url, params: params}.to change { User.count }.from(1).to(2)
        expect(response).to have_http_status(:success)
        expect(User.last.present?).to be true
        expect(User.last.admin?).to be true
      end

      it 'create customer' do
        user.merge!(admin_mode: false)
        params = { user: user }

        expect { post url, params: params }.to change { User.count }.from(0).to(1)
        expect(response).to have_http_status(:success)
        expect(User.last.present?).to be true
        expect(User.last.admin?).to be false
      end
    end
  end
end
