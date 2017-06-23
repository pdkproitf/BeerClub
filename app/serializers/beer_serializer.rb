class BeerSerializer < ActiveModel::Serializer
  attributes :id, :manufacurter, :name, :country, :price, :description
  belongs_to :category, serializer: CategorySerializer
end
