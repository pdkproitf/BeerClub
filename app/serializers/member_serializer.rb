class MemberSerializer < ActiveModel::Serializer
  belongs_to :user,  serializer: UserSerializer
  belongs_to :bar,   serializer: BarSerializer
end
