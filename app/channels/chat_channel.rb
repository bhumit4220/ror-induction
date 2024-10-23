class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:sender_id]}_#{params[:receiver_id]}"
  end

  def unsubscribed
  end

  def speak(data)
    message = Message.create!(sender_id: data['sender_id'], receiver_id: data['receiver_id'], message: data['message'])
    ActionCable.server.broadcast("chat_#{data['sender_id']}_#{data['receiver_id']}", {message: render_message(message, "sender"), user_id: data['receiver_id'], top: false})
    ActionCable.server.broadcast("chat_#{data['receiver_id']}_#{data['sender_id']}", {message: render_message(message, "receiver"), user_id: data['sender_id'], top: true})
    ActionCable.server.broadcast("notification_channel#{data['receiver_id']}",{ sender_id: message.sender_id, message: message.message, timestamp: message.created_at})
  end

  private

  def render_message(message, user_type)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, user_type: user_type })
  end
end
