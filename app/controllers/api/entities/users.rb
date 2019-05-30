module API
  module Entities
    class Users < Grape::Entity
      expose  :id, documentation: { type: 'integer', values: [Faker::Number.digit] }
      expose  :name, documentation: { type: 'string', values: [Faker::Name.name] }
      expose  :email, documentation: { type: 'string', values: [Faker::Internet.email] }
      # expose  :password, documentation: { type: 'string', values: [user.password] }
      # expose  :password_confirmation, documentation: { type: 'string', values: [user.password] }
    end

    class UsersLogin < Users
      expose  :token, documentation: { type: 'string', values:  ['eiyhyPFELGMbtqJg7Buvdyy5Buw0JzIq']}
      expose  :client, documentation: { type: 'string', values:  ['CBo21SyKATc3VX00ABuCOQ']}
    end

    class UsersPassports < Users
      expose :passport, using: API::Entities::Passports, documentation: { is_array: true }
    end
  end
end
