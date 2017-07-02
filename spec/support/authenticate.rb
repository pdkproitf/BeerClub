module Authenticate
  def auto_signin
    # create client id
    @user = FactoryGirl.create :user

    @client_id = SecureRandom.urlsafe_base64(nil, false)
    @token     = SecureRandom.urlsafe_base64(nil, false)

    @user.tokens[@client_id] = {
      token: BCrypt::Password.create(@token),
      expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
    }
    @user.save!
  end

  def headers
    auto_signin
    { 'Client': @client_id, 'Access-Token': @token }
  end
end
