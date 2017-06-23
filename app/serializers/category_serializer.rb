class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :archived

  belongs_to :bar, serializer: BarSerializer
end
