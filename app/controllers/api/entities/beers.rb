module API
  module Entities
    class Beers < Grape::Entity
      expose :id, documentation: { type: 'string', values: [Faker::Number.digit] }
      expose :name, documentation: { type: 'string', values: [Faker::Name.unique.name] }
      expose :price, documentation: { type: 'string', values: [Faker::Number.decimal(2)] }
      expose :country, documentation: { type: 'string', values: [Faker::Address.country] }
      expose :archived, documentation: { type: 'boolean', values: [false] }
      expose :description, documentation: { type: 'string', values: [Faker::Lorem.paragraph(2)] }
      expose :manufacurter, documentation: { type: 'string', values: [Faker::Educator.campus] }
    end

    class BeersCategory < Beers
      expose :category, using: API::Entities::Categories
    end

    class BeersArchive < Beers
      expose :archived, documentation: { type: 'boolean', values: [true] }
    end
  end
end
