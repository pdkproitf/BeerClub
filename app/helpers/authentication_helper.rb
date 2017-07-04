module AuthenticationHelper
  def authenticated!
    error!(I18n.t('Unauthor'), 401) unless current_user
  end

  def current_user
    # client_id = request.headers['Client']
    # token = request.headers['Access-Token']
    return nil unless params[:authentication_param]
    token = params[:authentication_param][:token]
    client_id = params[:authentication_param][:client]

    @current_user = User.find_by("tokens ? '#{client_id}'")

    return @current_user if @current_user && @current_user.valid_token?(token, client_id)
    @current_user = nil
  end

  # check is request of admin or without admin
  def admin_request?
    current_user && current_user.admin?
  end

  def response(messages, data = nil)
    {
      messages: messages,
      data: data
    }
  end
end
