module API
  module Entities
    class Passports < Grape::Entity
      expose :id, documentation: { type: 'string', values: [Faker::Number.digit] }
      expose :name, documentation: { type: 'string', values: [Faker::Name.name] }
    end
  end
end
