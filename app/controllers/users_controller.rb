
class UsersController < ApplicationController
  before_action :check_users_role, only: [:index]

  def index
    @users = User.order(created_at: :desc)
  end

  def favorite_books
    @books = current_user.favorite_books
  end

  private
  
  def check_users_role
    redirect_to request.referrer || root_path, alert: "You are not authorized to perform this action." unless current_user.admin?
  end
end
