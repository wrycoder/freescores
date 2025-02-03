class GenresController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit]

  def new
    @genre = Genre.new
  end

  def create
    begin
      Genre.create!(genre_params)
    rescue ActiveRecord::RecordInvalid => ex
      flash.now.alert = "#{ex.message}"
    end
    @genres = Genre.all
    render "index"
  end

  def index
    @genres = Genre.all
  end

  def edit
  end

  private
    def genre_params
      params.require(:genre).permit(:name, :vocal)
    end
end
