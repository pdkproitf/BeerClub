module API
  module V1
    class Conversations < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      resource :conversations do

        before do
          authenticated!
        end

        desc 'create new conversation', {
          detail: '',
          is_array: true,
          http_codes: [
            { code: 404, message: I18n.t('Unauthor') },
            { code: 201, message: I18n.t('success'), model: API::Entities::Conversations }
          ]
        }
        params do
          use :authentication_param
          requires :recipient_id, type: Integer, desc: 'id of recipient ex: 1'
        end
        post do
          error!(I18n.t('not_allow'), 406) if params[:recipient_id] == @current_user.id
          conversation = Conversation.get(@current_user.id, params[:recipient_id])
          response(I18n.t('success'), ConversationSerializer.new(conversation))
        end
      end
    end
  end
end
