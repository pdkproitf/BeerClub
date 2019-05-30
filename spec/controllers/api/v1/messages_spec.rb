require 'rails_helper'
include Authenticate

RSpec.describe 'Messages', type: :request do
  let(:url) { '/api/v1/messages' }
  let(:params) { sign_user }
  let(:message) { { user_id: @user.id, body: Faker::Name.name } }
  let!(:recipient) { FactoryGirl.create :user }

  describe 'POST api/v1/messages' do
    context 'Create' do

      it 'create a message' do
				params.merge!(message: message)
        conversation = Conversation.create!(sender_id: User.last.id, recipient_id: recipient.id)
				params.merge!(conversation_id: conversation.id)

				post url, params: params
        expect(response).to have_http_status(:success)
      end
    end
  end
end
