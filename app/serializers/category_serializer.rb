class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :archived
  has_many :beers, serializer: BeerSerializer
end
