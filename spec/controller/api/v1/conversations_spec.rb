require 'rails_helper'
include Authenticate

RSpec.describe 'Conversations', type: :request do
  let(:url) { '/api/v1/conversations' }
  let(:params) { sign_user }
  let!(:recipient) { FactoryGirl.build_stubbed :user }

  describe 'POST api/v1/conversations' do
    context 'Create' do
      it 'Create new conversations' do
        params.merge!(recipient_id: recipient.id)
        post url, params: params
        expect(response).to have_http_status(:created)
      end

      it 'get a conversation if conversation exist' do
        params.merge!(recipient_id: recipient.id)
        Conversation.create(sender_id: @user.id, recipient_id: recipient.id)
        post url, params: params

        expect(response).to have_http_status(:success)
      end
    end
  end
end
