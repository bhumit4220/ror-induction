class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
        
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

  private

  def assign_default_role
    self.add_role(:user) if roles.blank? # Assign 'user' role by default
  end
end
