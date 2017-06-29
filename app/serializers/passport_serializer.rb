class PassportSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :beers, serializer: BeerSerializer
  belongs_to :customer, serializer: CustomerSerializer
end
