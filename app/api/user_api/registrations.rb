module UserApi
  class Registrations < Grape::API
    prefix :api
    version 'v1', using: :path

    helpers RegistrationsHelper

    resource :users do
      # => /api/v1/users/
      desc 'create new user', entity: Entities::UserEntities::Users
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
