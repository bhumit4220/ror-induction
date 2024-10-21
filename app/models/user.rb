require 'jwt'
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :favorites, dependent: :destroy
  has_many :favorite_books, through: :favorites, source: :book
  has_many :devise_tokens
  enum role: %i[Admin User]
  after_create :assign_default_role
  
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
    self.add_role(:user) if roles.blank? # Assign 'user' role by default
  end
end
