module API
  module V1
    module Default
      extend ActiveSupport::Concern

      included do
        prefix 'api'
        version 'v1', using: :path
        default_format :json
        format :json
        
        helpers do
          params :authentication_param do
            optional :token, type: String, desc: 'authentication_token of the user. Example: lB8aDy7YUMcXTNH1uz_5fFTFfCo'
            optional :client, type: String, desc: 'Client_id user. Example: 5D37C843-2316-443B-9AC6-149597A4E1A8'
          end
        end
      end
    end
  end
end
