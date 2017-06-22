module Entities
  module UserEntities
    class Users < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      expose :name, documentation: { type: 'string', values: ['Ryan Pham'] }
      expose  :email, documentation: { type: 'string', values: ['ryanpham@gmail.com'] }
      expose  :password, documentation: { type: 'string', values: ['ryanpham'] }
      expose  :password_confirmation, documentation: { type: 'string', values: ['ryanpham'] }

      with_options(format_with: :ios_timestamp) do
        expose  :created_at, documentation: { type: 'integer', values: [1481461392] }
        expose  :updated_at, documentation: { type: 'integer', values: [1481461392] }
      end
    end
  end
end
