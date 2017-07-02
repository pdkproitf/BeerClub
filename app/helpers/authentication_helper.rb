module AuthenticationHelper
  def authenticated!
    error!(I18n.t('Unauthor'), 401) unless current_user
  end

  def current_user
    client_id = request.headers['Client']
    token = request.headers['Access-Token']

    @current_user = User.find_by("tokens ? '#{client_id}'")

    return @current_user if !@current_user.nil? && @current_user.valid_token?(token, client_id)
    @current_user = nil
  end

  # check is request of admin or without admin
  def admin_request?
    !current_user.blank? && current_user.admin?
  end

  def return_message(status, data = nil)
    {
      status: status,
      data: data
    }
  end
end
