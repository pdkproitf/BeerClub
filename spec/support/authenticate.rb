module Authenticate
  def auto_signin(user, admin = true)
    @client_id = SecureRandom.urlsafe_base64(nil, false)
    @token     = SecureRandom.urlsafe_base64(nil, false)

    user.tokens[@client_id] = {
      token: BCrypt::Password.create(@token),
      expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
    }
    role_name = admin ? 'Admin' : 'Customer'
    user.role_id = Role.find_or_create_by(name: role_name).id
    user.save!
    @user = user
  end

  def sign_user
    auto_signin(FactoryGirl.create :user)
    # { 'Client': @client_id, 'Access-Token': @token }
    { token: @token, client: @client_id }
  end

  def sign_customer
    auto_signin(FactoryGirl.create :user, false)
    # { 'Client': @client_id, 'Access-Token': @token }
    { token: @token, client: @client_id }
  end
end
