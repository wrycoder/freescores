class SessionsController < ApplicationController
  def create
    if authenticate(session_params[:password])
      flash[:success] = "You are now logged in"
      redirect_to session_params[:forwarding_url]
    else
      flash[:alert] = "Login failed"
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
    def session_params
      params.require(:session).permit(:password, :forwarding_url)
    end
end
