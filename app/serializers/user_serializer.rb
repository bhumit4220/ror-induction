class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at

  attribute :auth_token
  def auth_token
    @instance_options[:token].try(:auth_token)
  end
end
