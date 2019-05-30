module RegistrationsHelper
  # Strong param for user
  def create_params
    ActionController::Parameters.new(params).require(:user)
      .permit(:name, :email, :password, :password_confirmation)
  end

  def save_user(user)
    @resource ||= user
    if @resource.save!
      # email auth has been bypassed, authenticate user
      @client_id = SecureRandom.urlsafe_base64(nil, false)
      @token = SecureRandom.urlsafe_base64(nil, false)

      @resource.tokens[@client_id] = {
        token: BCrypt::Password.create(@token),
        expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
      }

      @resource.save!
    end
  end

  def add_role(name = 'Admin')
    role = Role.find_or_create_by(name: name)
    @resource.role_id = role.id
  end
end
