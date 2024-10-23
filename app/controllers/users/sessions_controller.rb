# app/controllers/users/sessions_controller.rb
module Users
  class SessionsController < Devise::SessionsController
    def destroy
      if current_user
        current_user.update(online: false)
      end
      super
    end
  end
end
