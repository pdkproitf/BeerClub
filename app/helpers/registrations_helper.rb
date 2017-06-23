module RegistrationsHelper
  def create_params
    ActionController::Parameters.new(params).require(:user)
      .permit(:name, :email, :password, :password_confirmation)
  end

  def create_member
    @role = Role.find_or_create_by(name: 'Admin')
    @bar.members.new(user_id: @resource.id, role_id: @role.id)
  end

  def build_new_user
    @resource = User.new(create_params)
    @resource.provider = 'email'

    Bar.transaction do
      User.transaction do
        @bar.save!
        save_user
      end
    end
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

      @member = create_member
      Member.transaction do
        @member.save!
      end

      return_message(I18n.t('success'), MemberSerializer.new(@member))
    end
  end
end
