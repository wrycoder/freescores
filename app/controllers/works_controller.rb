class WorksController < ApplicationController
  def create
  end

  def index
    @works = Work.all
  end

  def show
    @work = Work.find(params[:id])
  end

  def update
  end

  def delete
  end
end
