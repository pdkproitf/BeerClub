module API
  module Entities
    class Categories < Grape::Entity
      category = FactoryGirl.build(:category, name: Faker::Name.unique.name)
      expose :id, documentation: { type: 'string', values: [Faker::Number.digit] }
      expose :name, documentation: { type: 'string', values: [category.name] }
      expose :archived, documentation: { type: 'boolean', values: [false] }
    end

    class CategoryBeers < Categories
      expose :beers, using: API::Entities::Beers, documentation: { type: Array, is_array: true }
    end

    class CategoryArchived < CategoryBeers
      expose :archived, documentation: { type: 'boolean', values: [true] }
    end
  end
end
