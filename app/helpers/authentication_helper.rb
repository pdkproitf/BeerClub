module AuthenticationHelper
    def authenticated!
        error!(I18n.t('Unauthor'), 401) unless current_member
    end

    def current_user
      binding.pry
        client_id = request.headers['Client']
        token = request.headers['Access-Token']

        current_user = User.find_by("tokens ? '#{client_id}'")

        return current_user unless current_user.nil? || !current_user.valid_token?(token, client_id)
        current_user = nil
    end

    def current_member
        bar_name = request.headers['Bar-Name']
        user = current_user
        return nil unless user

        bar = user.bars.find_by_name(bar_name)
        return nil unless bar

        @current_member = user.members.find_by_bar_id(bar.id)
    end

    def return_message(status, data = nil)
        {
            status: status,
            data: data
        }
    end
end
