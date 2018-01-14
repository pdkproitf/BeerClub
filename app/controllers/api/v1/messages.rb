module API
  module V1
    class Messages < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      helpers do
        def message_params
          ActionController::Parameters.new(params).require(:message)
            .permit(:user_id, :body)
        end
      end

      resource :messages do

        before do
          authenticated!
        end

        desc 'create new messages', {
          detail: 'send message',
          http_codes: [
            { code: 404, message: I18n.t('Unauthor') },
            { code: 201, message: I18n.t('success'), model: API::Entities::Messages }
          ]
        }
        params do
          use :authentication_param
          requires :conversation_id, type: Integer, desc: 'id of conversation ex: 1'
          requires :message, type: Hash do
            requires :user_id, type: Integer, desc: 'id of user ex: 1'
            requires :body, type: String, desc: 'message content ex: i love you'
          end
        end
        post do
          conversation = Conversation.includes(:recipient).find(params[:conversation_id])
          message = conversation.messages.create(message_params)

          response(I18n.t('success'), MessageSerializer.new(message))
        end
      end
    end
  end
end
