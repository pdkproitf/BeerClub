class MessageSerializer < ActiveModel::Serializer
  attributes :id, :conversation_id, :body
  belongs_to :user
end
