class DashboardController < ApplicationController
  before_action :logged_in_user
  def show
    flash.now[:notice] = "Choose from the following options"
  end
end
