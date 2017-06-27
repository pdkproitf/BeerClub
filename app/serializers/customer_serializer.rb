class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_one :passport, serializer: PassportSerializer
end
