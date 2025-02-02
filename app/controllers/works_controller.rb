class WorksController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :edit]

  def new
  end

  def create
  end

  def index
    if params[:sort_key].present?
      if params[:descending].present?
        @works = Work.all.order({params[:sort_key].to_sym => :desc})
      else
        @works = Work.all.order(params[:sort_key])
      end
    else
      @works = Work.all.sort { |a,b| a.composed_in <=> b.composed_in }
    end
  end

  def show
    @work = Work.find(params[:id])
  end

  def edit
  end

  def update
  end

  def delete
  end
end
