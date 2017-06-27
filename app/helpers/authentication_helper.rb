module AuthenticationHelper
    def authenticated!
        error!(I18n.t('Unauthor'), 401) unless current_user && current_user.admin?
    end

    def current_user
        client_id = request.headers['Client']
        token = request.headers['Access-Token']

        @current_user = User.find_by("tokens ? '#{client_id}'")

        return @current_user unless @current_user.nil? || !@current_user.valid_token?(token, client_id)
        @current_user = nil
    end

    def return_message(status, data = nil)
        {
            status: status,
            data: data
        }
    end
end
