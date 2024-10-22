class UsersOnlineChannel < ApplicationCable::Channel
  def subscribed
    stream_from "users_online_channel"
  end
end
