class Api::V1::BaseController < ApplicationController
  
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!
  before_action :verify_token
  
  rescue_from ActiveRecord::RecordNotFound do |error|
    api_error(400, error.message)
  end

  private

  # Method for render response as error
  def api_error(status = 500, errors = [], data = {})
    render json: { data: {}, type: 'Error', status: status, message: errors, data: data}, status: status
  end

  # Method for render response as success
  def api_success(status = 200, msg = [], data = {})
    render json: { data: data, type: 'Success', status: status, message: msg }, status: status
  end

  def collection_serializer(collection, serializer, instance = [])
    ActiveModel::Serializer::CollectionSerializer.new(collection, serializer: serializer, data: instance)
  end

  def verify_auth_token
    @current_user = DeviseToken.find_by(auth_token: request.headers['TOKEN']).try(:user)
  end

  def verify_token
    token = request.headers['TOKEN']
    @user = DeviseToken.find_by(auth_token: token)&.user
    return api_error(400, 'Please login to process further.') unless @user
    decoded_data = Jwt.new(@user&.id, token).decode_token
    begin
      decoded_data.first['user_id'] == @user.id
    rescue JSON::ParserError
      api_error(400, 'Please login to process further.')
    end
  end
  
  # Get error message from object
  def get_error_messages(object)
    object.errors.first.message
  end

  def api_error_messages(object)
    object.errors.messages.values.uniq.join(',')
  end
end
