# app/channels/notification_channel.rb
class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when the channel is unsubscribed
  end
end
