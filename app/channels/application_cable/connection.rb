  module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      self.current_user = find_verified_user
      current_user.update(online: true) if current_user
    end
  
    def disconnect
      current_user.update(online: false) if current_user
    end
  
    private
  
    def find_verified_user
      if env['warden'].user
        logger.info "Verified user: #{env['warden'].user.id}"
        env['warden'].user
      else
        reject_unauthorized_connection
      end
    end
  end
end
