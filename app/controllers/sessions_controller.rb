class SessionsController < ApplicationController
  def create
    if authenticate(params[:session][:password])
      redirect_to params[:session][:forwarding_url]
    else
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
