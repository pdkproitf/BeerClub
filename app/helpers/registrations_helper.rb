module RegistrationsHelper
  def create_params
    ActionController::Parameters.new(params).require(:user)
    .permit(:name, :email, :password, :password_confirmation)
  end

  def create_member
    @company.members.new(user_id: @resource.id, role_id: @role.id)
  end

  def save_user
    if @resource.save!
      # email auth has been bypassed, authenticate user
      @client_id = SecureRandom.urlsafe_base64(nil, false)
      @token = SecureRandom.urlsafe_base64(nil, false)

      @resource.tokens[@client_id] = {
        token: BCrypt::Password.create(@token),
        expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
      }
      @resource.save!

      return_message(I18n.t('success'), @resource)
    end
  end

  def update_params
    ActionController::Parameters.new(params).require(:user)
    .permit(:first_name, :last_name, :image)
  end
end
