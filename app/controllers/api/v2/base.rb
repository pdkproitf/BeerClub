require 'grape-swagger'

module API
  module V2
    class Base < Grape::API
      format :json
      formatter :json, Grape::Formatter::ActiveModelSerializers

      helpers AuthenticationHelper

      mount API::V2::Registrations
      mount API::V2::Sessions
      #
      # mount API::V2::Categories
      # mount API::V2::Beers
      # mount API::V2::Passports

      # actioncable
      # mount API::V1::Conversations
      # mount API::V1::Messages

      add_swagger_documentation(
        api_version: 'v2',
        hide_doccumentation_path: false,
        mount_path: '/api/v2/swagger_doc',
        hide_format: true,
        info: {
          title: 'BEER CLUB'
        }
      )
    end
  end
end
