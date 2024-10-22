class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:sender_id]}_#{params[:receiver_id]}"
    update_user_status(true)
  end

  def unsubscribed
    update_user_status(false)
  end

  def speak(data)
    puts "###################################################in channge########{data}"
    message = Message.create!(sender_id: data['sender_id'], receiver_id: data['receiver_id'], message: data['message'])
    ActionCable.server.broadcast("chat_#{data['sender_id']}_#{data['receiver_id']}", {message: render_message(message, "sender")})
    ActionCable.server.broadcast("chat_#{data['receiver_id']}_#{data['sender_id']}", {message: render_message(message, "receiver")})
  end

  private

  def render_message(message, user_type)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, user_type: user_type })
  end

  def update_user_status(online)
    user = User.find(params[:sender_id])
    user.update(online: online)
  end
end
