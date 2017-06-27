class BeerSerializer < ActiveModel::Serializer
  attributes :id, :manufacurter, :name, :country, :price, :description, :count, :archived
  belongs_to :category, serializer: CategorySerializer
end
