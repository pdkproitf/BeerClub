class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    sender = message.user
    recipient = message.conversation.opposed_user(sender)

    # broadcast_to_sender(sender, message)
    broadcast_to_recipient(recipient, message)
  end

  private
  #
  # def broadcast_to_sender(user, message)
  #   ActionCable.server.broadcast(
  #     "conversations-#{user.id}",
  #     message: 'broadcast',
  #     data: MessageSerializer.new(message)
  #   )
  # end

  def broadcast_to_recipient(user, message)
    ActionCable.server.broadcast(
    "conversations-#{user.id}",
    message: 'broadcast',
    data: MessageSerializer.new(message)
    )
  end
end
