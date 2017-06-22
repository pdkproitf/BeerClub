class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :bars, through: :bar_categories, serializer: BarSerializer
end
