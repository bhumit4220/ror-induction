class Jwt
  HMAC_SECRET = "ror-induction-training"
  def initialize(user_id, token)
    @user_id = user_id
    @token = token
  end
  
  def generate_token
    payload = {user_id: @user_id}
    JWT.encode payload, HMAC_SECRET, 'HS256'
  end

  def decode_token
    JWT.decode @token, HMAC_SECRET, true, { algorithm: 'HS256' }
  end
end
