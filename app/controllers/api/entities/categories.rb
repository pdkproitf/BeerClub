module API
  module Entities
    class Categories < Grape::Entity
      category = FactoryGirl.create(:category)
      expose :id, documentation: { type: 'string', values: [category.id] }
      expose :name, documentation: { type: 'string', values: [category.name] }
    end
  end
end
