class MessageSerializer < ActiveModel::Serializer
  attributes :id, :conversation_id, :body, :user
  # belongs_to :user

  def user
    object.user
  end
end
