class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :bar, serializer: BarSerializer
end
