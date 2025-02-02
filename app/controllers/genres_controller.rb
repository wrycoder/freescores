class GenresController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit]

  def new
  end

  def create
  end

  def index
  end

  def edit
  end
end
