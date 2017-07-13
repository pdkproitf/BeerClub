class PassportBeerSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :passport
  belongs_to :beer
end
