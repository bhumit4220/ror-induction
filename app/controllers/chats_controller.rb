class ChatsController < ApplicationController

  def index
    @users = User.where.not(id: current_user).order(:id)
  end

  def conversation
    @users = User.where.not(id: current_user).order(:id)
    @sender = current_user
    @receiver = User.find(params[:id])
    @messages = Message.where(sender: @sender, receiver: @receiver).or(Message.where(sender: @receiver, receiver: @sender)).order(:created_at)
  end
end
