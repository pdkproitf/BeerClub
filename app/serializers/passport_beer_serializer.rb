class PassportBeerSerializer < ActiveModel::Serializer
  belongs_to :passport
  belongs_to :beer
end
