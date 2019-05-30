module API
  module Entities
    class Conversations < Grape::Entity
      expose :id, documentation: { type: 'integer', values: [Faker::Number.digit] }
      expose :sender, using: API::Entities::Users
      expose :recipient, using: API::Entities::Users
      expose :messages, using: API::Entities::Messages, documentation: { is_array: true }
    end
  end
end
