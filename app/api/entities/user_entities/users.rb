module Entities
  module UserEntities
    class Users < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      expose :name, documentation: { type: 'string', values: ['Ryan Pham'] }
      expose  :email, documentation: { type: 'string', values: ['ryanpham@gmail.com'] }
      expose  :password, documentation: { type: 'string', values: ['ryanpham'] }
      expose  :password_confirmation, documentation: { type: 'string', values: ['ryanpham'] }
    end
  end
end
