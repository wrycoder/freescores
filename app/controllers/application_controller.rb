class ApplicationController < ActionController::Base
  include SessionsHelper

  private
    def logged_in_user
      unless logged_in?
        store_location
        flash[:alert] = "Please log in."
        redirect_to sessions_new_path
      end
    end

end
