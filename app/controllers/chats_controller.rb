class ChatsController < ApplicationController
  before_action :load_users

  def index
  end

  def conversation
    @sender = current_user
    @receiver = User.find(params[:id])
    @messages = Message.where(sender: @sender, receiver: @receiver).or(Message.where(sender: @receiver, receiver: @sender)).order(:created_at)
    @messages.update_all(read_by_receiver: true)
  end

  def load_users
    unread_users_query = User.select('users.*, COUNT(messages.id) AS unread_count, MAX(messages.created_at) AS last_message_time').joins("LEFT JOIN messages ON messages.sender_id = users.id AND messages.receiver_id = #{current_user.id} AND messages.read_by_receiver = false").where.not(id: current_user.id).group('users.id').having('COUNT(messages.id) > 0').order('last_message_time DESC')
    
    user_ids = ([current_user.id] + unread_users_query&.map(&:id).to_a).uniq
    seen_messages_query = User.select('users.*, COUNT(messages.id) AS seen_count, MAX(messages.created_at) AS last_message_time').joins("LEFT JOIN messages ON messages.sender_id = users.id AND messages.receiver_id = #{current_user.id} AND messages.read_by_receiver = true").where.not(id: user_ids).group('users.id').having('COUNT(messages.id) > 0')
    user_ids = (user_ids << seen_messages_query.map(&:id)).flatten.uniq
    zero_message_users_query = User.where.not(id: user_ids).order('updated_at DESC')
    @users = unread_users_query.to_a + seen_messages_query.to_a + zero_message_users_query.to_a
  end
end
