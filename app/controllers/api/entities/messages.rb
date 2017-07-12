module API
  module Entities
    class Messages < Grape::Entity
      expose  :id, documentation: { type: 'integer', values: [Faker::Number.digit] }
      expose  :conversation_id, documentation: { type: 'integer', values: [Faker::Number.digit] }
      expose  :body, documentation: { type: 'string', values: [Faker::Lorem.paragraph(2)] }
      expose :sender, using: API::Entities::Users
      expose :recipient, using: API::Entities::Users
    end
  end
end
