module API
  module Entities
    class Passports < Grape::Entity
      expose :id, documentation: { type: 'string', values: [Faker::Number.digit] }
      expose :name, documentation: { type: 'string', values: [Faker::Name.name] }
    end

    class PassportsBeer < Grape::Entity
      expose :beers, using: API::Entities::Beers
      expose :passport, using: API::Entities::Passports
    end
  end
end
