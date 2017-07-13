module API
  module Entities
    class Beers < Grape::Entity
      category = FactoryGirl.create(:category, name: Faker::Name.name)
      beer = FactoryGirl.create(:beer, category: category)
      expose :id, documentation: { type: 'string', values: [Faker::Number.digit] }
      expose :name, documentation: { type: 'string', values: [beer.name] }
      expose :price, documentation: { type: 'string', values: [beer.price] }
      expose :country, documentation: { type: 'string', values: [beer.country] }
      expose :archived, documentation: { type: 'boolean', values: [false] }
      expose :description, documentation: { type: 'string', values: [beer.description] }
      expose :manufacurter, documentation: { type: 'string', values: [beer.manufacurter] }
    end

    class BeersCategory < Beers
      expose :category, using: API::Entities::Categories
    end

    class BeersArchive < Beers
      expose :archived, documentation: { type: 'boolean', values: [true] }
    end
  end
end
