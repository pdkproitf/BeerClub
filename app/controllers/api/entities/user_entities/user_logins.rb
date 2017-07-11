module API
  module Entities
    module UserEntities
      class UserLogins < Grape::Entity
        format_with(:iso_timestamp) { |dt| dt.iso8601 }
        user = FactoryGirl.build :user, email: Faker::Internet.email, role: Role.find_or_create_by(name: 'Admin')
        expose  :email, documentation: { type: 'string', values: [user.email] }
        expose  :password, documentation: { type: 'string', values: [user.password] }
      end
    end
  end
end
