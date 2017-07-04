module API
  module Entities
    module UserEntities
      class UserLogins < Grape::Entity
        format_with(:iso_timestamp) { |dt| dt.iso8601 }

        expose  :email, documentation: { type: 'string', values: ['ryanpham@gmail.com'] }
        expose  :password, documentation: { type: 'string', values: ['ryanpham'] }
      end
    end
  end
end
