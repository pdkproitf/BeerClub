module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include AuthenticationHelper

    identified_by :connect_user

    def connect
      self.connect_user = find_verified_user
    end

    protected

    def find_verified_user
      current_user || reject_unauthorized_connection
    end
  end
end
