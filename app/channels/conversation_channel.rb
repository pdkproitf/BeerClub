class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations-#{connect_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
