
require 'jwt'
class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :verify_token, only: %i[log_in registration]
  before_action :find_user, only: %i[log_in]

  def index
    @users = User.order(created_at: :desc)
    api_success '200', 'Users fetched successfully', collection_serializer(@users, UserSerializer)
  end

  def registration
    @user = User.new(sign_up_params)

    if @user.save
      api_success(200, 'User created successfully.', UserSerializer.new(@user))
    else
      api_error(400, @user.errors.full_messages)
    end
  end

  def log_in
    if (@user.valid_password?(params[:password]))
      token = @user.genrate_device_token
      api_success(200, 'Sign in successfully!', UserSerializer.new(@user, token: token))
    else
      api_error(400, 'Invalid Email or Password')
    end
  end

  def log_out
    @user = User.find_by_email(params[:email].downcase)
    if @user.devise_tokens.destroy_all
      api_success(200, 'User logout successfully.')
    else
      api_error(400, 'No User found with this email.')
    end
  end

  private

  def find_user
    @user = User.find_by_email(params[:email])
    return api_error(400, 'User Not Found.') unless @user.present?
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
