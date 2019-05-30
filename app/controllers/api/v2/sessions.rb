module API
  module V2
    class Sessions < Grape::API
      prefix  :api
      version 'v2', using: :path
      include API::V1::Default

      helpers do
        # return login information to user.
        def sign_in_token_validation
          data  = @resource.token_validation_response.to_h
          data.store('client', @client_id)
          data.store('token', @token)
          data
        end

        def create_client_id_and_token
          # create client id
          @client_id = SecureRandom.urlsafe_base64(nil, false)
          @token     = SecureRandom.urlsafe_base64(nil, false)

          @resource.tokens[@client_id] = {
            token: BCrypt::Password.create(@token),
            expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
          }
          @resource.save!
        end
      end

      resource :users do
        # => /api/v1/users/
        desc 'sign-in' do
          entity API::Entities::UsersLogin.documentation
          detail ''
          success code: 201, message: I18n.t('devise.sessions.signed_in'), model: API::Entities::UsersLogin
          failure [{ code: 500, message: I18n.t('devise_token_auth.sessions.bad_credentials') }]
        end
        params do
          requires :user, type: Hash do
            requires :email, type: String, desc: 'User\'s Email'
            requires :password,  type: String, desc: 'password'
          end
        end
        post '/sign-in' do
          @resource = User.find_by(email: params['user'][:email])
          if @resource and @resource.valid_password?(params['user']['password']) and
            (!@resource.respond_to?(:active_for_authentication?) or @resource.active_for_authentication?)

            create_client_id_and_token
            response(I18n.t('devise.sessions.signed_in'), sign_in_token_validation)
          else
            error!(I18n.t('devise_token_auth.sessions.bad_credentials'), 500)
          end
        end

        desc 'sign-out' do
          detail ''
          success code: 201, message: I18n.t('devise.sessions.signed_out')
          failure [{ code: 404, message: I18n.t('devise_token_auth.sessions.user_not_found') }]
        end
        params do
          requires :user, type: Hash do
            requires :uid, type: String, desc: 'uid'
            requires :client,  type: String, desc: 'client'
            requires :access_token,  type: String, desc: 'access-token'
          end
        end
        post '/sign-out' do
          @resource = User.find_by(email: params['user']['uid'])
          @client_id = params['user']['client']
          @token = params['user']['access_token']

          user = remove_instance_variable(:@resource) if @resource
          client_id = remove_instance_variable(:@client_id) if @client_id
          token = remove_instance_variable(:@token) if @token

          if user and client_id and user.valid_token?(token, client_id)
            user.tokens.delete(client_id)
            user.save!
            response I18n.t('devise.sessions.signed_out')
          else
            error!(I18n.t('devise_token_auth.sessions.user_not_found'), 404)
          end
        end
      end
    end
  end
end
