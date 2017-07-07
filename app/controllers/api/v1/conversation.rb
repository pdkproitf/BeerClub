module API
  module V1
    class Conversations < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      resource :conversations do
        # => /api/v1/users/
        desc 'create new user' , entity: API::Entities::UserEntities::Users

      end
    end
  end
end
