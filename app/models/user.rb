class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
        
  enum role: %i[Admin User]

  def full_name
    [first_name, last_name].join(" ")
  end

  def admin?
    has_role?(:admin)
  end
  

  def user?
    has_role?(:user)
  end 
end
