class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations-#{connect_user.id}"
    list_friend
  end

  def unsubscribed
    stop_all_streams
  end

  # return list friend when has user connect to channel
  def list_friend
    ActionCable.server.broadcast(
    "conversations-#{connect_user.id}",
    message: 'list_user',
    data: User.where.not(id: connect_user).select('id, email')
    )
  end
end
