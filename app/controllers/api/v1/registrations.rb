module API
  module V1
    class Registrations < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      helpers RegistrationsHelper

      resource :users do
        # => /api/v1/users/
        desc 'create new user', {
          entity: API::Entities::UserEntities::Users.documentation,
          detail: '',
          success:{ code: 201, message: I18n.t('success'), model: API::Entities::UserEntities::Users },
          failure: [{ code: 401, message: I18n.t('Unauthor') } ,
                    { code: 400, message: "Validation failed" }]
        }
        params do
          requires :user, type: Hash do
            requires :name, type: String, desc: 'Name'
            requires :email, type: String, desc: "User's Email"
            requires :password, type: String, desc: 'password'
            requires :password_confirmation, type: String, desc: 'password_confirmation'
            requires :admin_mode, type: Boolean, desc: 'mode access, true -> create admin account, false -> create customer account'
          end
        end
        post do
          if params[:user][:admin_mode]
            authenticated!

            @resource = User.new(create_params)
            @resource.provider = 'email'

            User.transaction do
              add_role
              save_user
              response(I18n.t('success'), UserSerializer.new(@resource))
            end
          else
            @resource = Customer.new(create_params)
            @resource.provider = 'email'
            Customer.transaction do
              save_user
              response(I18n.t('success'), CustomerSerializer.new(@resource))
            end
          end
        end
      end
    end
  end
end
