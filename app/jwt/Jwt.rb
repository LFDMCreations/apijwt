class UserJWT

  attr_reader :duration, :token, :user

  def initialize (user)
    @user = user 
    @hmac_secret = "7f95cb98b1158f9f2ea9d9f13816786144e4ad8eb6c33483g9636f9f0d328c23fc1ab2be6f2b0e4250349807e78055a8d18a03735171179dfce6ff7d2e3afe86"
  end

  def duration=(duration)
    # duration in seconds
    @duration = Time.now.to_i + duration
  end

  def issue
    payload = { user: @user, exp: @duration }
    @token = JWT.encode payload, @hmac_secret, 'HS256'
  end

  def readheader(header)
    @token = header.split.last
  end

  def self.verify(token)
    # returns the token content
    begin
      # https://github.com/jwt/ruby-jwt
      # this verifies signature, data and jwt expiration (tested in racksh):
      hmac_secret = "7f95cb98b1158f9f2ea9d9f13816786144e4ad8eb6c33483g9636f9f0d328c23fc1ab2be6f2b0e4250349807e78055a8d18a03735171179dfce6ff7d2e3afe86"
      decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
      user = decoded_token[0]["user"]
    rescue JWT::VerificationError
      # return 'clef invalide'
      return false
    rescue JWT::ExpiredSignature
      # return 'durée expirée'
      return false
    end
  end

end


class UserJwtRefresh
  attr_reader :duration, :token, :user

  def initialize (user)
    @user = user 
    @hmac_refresh = "7f95cb98b1158f9f2ea9d9f13816786144e4ad8eb6c33483g9636f9f0d328c23fc1ab2be6f2b0e4250349807e78055a8d18a03735171179dfce6ff7d2e3afe86"
  end

  def issue()
    duration = Time.now.to_i + 60 # 1 minute for testing purpose
    payload = { user: @user, exp: duration }
    JWT.encode payload, @hmac_refresh, 'HS256'
  end

  def verify(token)
    begin
      decoded_token = JWT.decode token, @hmac_refresh, { algorithm: 'HS256' }
      @user = decoded_token[0]["user"]
    rescue JWT::VerificationError
      return 'clef invalide'
    rescue JWT::ExpiredSignature
      return 'refresh expiré'
    end
  end

  def logout(id)
    if UserJwtRefresh.where(user_id: id).first.delete
      return true
    end
  end

end