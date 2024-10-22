require 'jwt'
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :favorites, dependent: :destroy
  has_many :favorite_books, through: :favorites, source: :book
  has_many :devise_tokens
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  enum role: %i[Admin User]
  after_create :assign_default_role
  after_update :broadcast_online_status, if: :saved_change_to_online?

  def full_name
    [first_name, last_name].join(" ")
  end
  
  def admin?
    has_role?(:admin)
  end
  
  def user?
    has_role?(:user)
  end 
  
  def genrate_device_token
    devise_tokens.create(auth_token: Jwt.new(id, nil).generate_token)
  end

  def user_roles
    roles.pluck(:name).join(", ")
  end

  private

  def assign_default_role
    self.add_role(:user) if roles.blank?
  end

  def broadcast_online_status
    ActionCable.server.broadcast "users_online_channel", { user_id: id, online: online }
  end
end
