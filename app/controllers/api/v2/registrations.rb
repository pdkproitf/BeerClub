module API
  module V2
    class Registrations < Grape::API
      prefix :api
      version 'v2', using: :path
      include API::V1::Default

      helpers RegistrationsHelper

      resource :users do
        # => /api/v2/users/
        desc 'create new user' do
          entity API::Entities::Users.documentation
          detail ''
          success code: 201, message: I18n.t('success'), model: API::Entities::UsersPassports
          failure [{ code: 401, message: I18n.t('Unauthor') } ,
                   { code: 400, message: "Validation failed" }]
        end
        params do
          use :authentication_param
          requires :user, type: Hash do
            requires :name, type: String, desc: 'Name'
            requires :email, type: String, desc: "User's Email"
            requires :password, type: String, desc: 'password'
            requires :password_confirmation, type: String, desc: 'password_confirmation'
            requires :admin_mode, type: Boolean, desc: 'mode access, true -> create admin account, false -> create customer account'
          end
        end
        post do
          role_name = 'Customer'
          if params[:user][:admin_mode]
            authenticated!
            role_name = 'Admin'
          end

          @resource = User.new(create_params)
          @resource.provider = 'email'

          User.transaction do
            add_role(role_name)
            save_user
            response(I18n.t('success'), UserSerializer.new(@resource))
          end
        end
      end
    end
  end
end
