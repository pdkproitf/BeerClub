require 'grape-swagger'

module API
  module V1
    class Base < Grape::API
      format :json
      formatter :json, Grape::Formatter::ActiveModelSerializers
      use API::V1::ApiErrorHandler

      helpers AuthenticationHelper

      mount API::V1::Registrations
      mount API::V1::Sessions
      #
      mount API::V1::Categories
      mount API::V1::Beers
      mount API::V1::Passports

      # actioncable
      mount API::V1::Conversations
      mount API::V1::Messages

      add_swagger_documentation(
        api_version: 'v1',
        hide_doccumentation_path: false,
        mount_path: '/api/v1/swagger_doc',
        hide_format: true,
        info: {
          title: 'BEER CLUB'
        }
      )
    end
  end
end
