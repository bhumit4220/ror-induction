  module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
    end
  
    def disconnect
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
