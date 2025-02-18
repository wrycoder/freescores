class GenresController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit]

  def new
    flash.now[:notice] = "Define the new genre's properties"
    @genre = Genre.new
  end

  def create
    begin
      Genre.create!(genre_params)
    rescue ActiveRecord::RecordInvalid => ex
      flash.now.alert = "#{ex.message}"
    end
    flash.now[:notice] = "Genre created"
    @genres = Genre.all
    render "index"
  end

  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.find(params[:id])
    @works = Work.where(genre: @genre)
    @path = url_for(works_path)
    render "works/index", status: :ok
  end

  def edit
  end

  private
    def genre_params
      params.require(:genre).permit(:name, :vocal)
    end
end
