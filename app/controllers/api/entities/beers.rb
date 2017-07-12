module API
  module Entities
    class Beers < Grape::Entity
      beer = FactoryGirl.create(:beer)
      expose :id, documentation: { type: 'string', values: [Faker::Number.digit] }
      expose :manufacurter, documentation: { type: 'string', values: [beer.manufacurter] }
      expose :name, documentation: { type: 'string', values: [beer.name] }
      expose :country, documentation: { type: 'string', values: [beer.country] }
      expose :price, documentation: { type: 'string', values: [beer.price] }
      expose :description, documentation: { type: 'string', values: [beer.description] }
      expose :category_id, documentation: { type: 'string', values: [beer.category.id] }
    end
  end
end
