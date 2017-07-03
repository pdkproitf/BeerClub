module Authenticate
  def auto_signin(user)
    @client_id = SecureRandom.urlsafe_base64(nil, false)
    @token     = SecureRandom.urlsafe_base64(nil, false)

    user.tokens[@client_id] = {
      token: BCrypt::Password.create(@token),
      expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
    }
    user.save!
    user
  end

  def headers
    auto_signin(FactoryGirl.create :user)
    { 'Client': @client_id, 'Access-Token': @token }
  end

  def sign_customer
    auto_signin(FactoryGirl.create :customer)
    { 'Client': @client_id, 'Access-Token': @token }
  end
end
