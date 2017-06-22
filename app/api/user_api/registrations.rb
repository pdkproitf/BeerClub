module UserApi
  class Registrations < Grape::API
    prefix :api
    version 'v1', using: :accept_version_header

    helpers RegistrationsHelper

    resource :users do
      # => /api/v1/users/
      desc 'create new user', entity: Entities::UserEntities::Users
      params do
        requires :user, type: Hash do
          requires :bar_name, type: String, desc: 'Name of a Bar'
          requires :name, type: String, desc: 'Name'
          requires :email, type: String, desc: "User's Email"
          requires :password, type: String, desc: 'password'
          requires :password_confirmation, type: String, desc: 'password_confirmation'
        end
      end
      post '/' do
        @resource = User.new(create_params)
        @resource.provider = 'email'

        @bar = Bar.new(name: params[:user][:bar_name])
        Bar.transaction do
          User.transaction do
            @bar.save!
            save_user
          end
        end
      end
    end
  end
end
