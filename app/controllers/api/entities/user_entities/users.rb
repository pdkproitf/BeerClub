module API
  module Entities
    module UserEntities
      class Users < Grape::Entity
        format_with(:iso_timestamp) { |dt| dt.iso8601 }
        user = FactoryGirl.build :user, email: Faker::Internet.email, role: Role.find_or_create_by(name: 'Admin')

        expose :name, documentation: { type: 'string', values: [user.name] }
        expose  :email, documentation: { type: 'string', values: [user.email] }
        expose  :password, documentation: { type: 'string', values: [user.password] }
        expose  :password_confirmation, documentation: { type: 'string', values: [user.password] }
      end
    end
  end
end
