class WorksController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :edit]

  def new
    @work = Work.new
    6.times { @work.parts.build }
  end

  def create
    begin
      # work_params["parts_attributes"] = work_params["parts_attributes"].except(empty_fields)
      @work = Work.build_from_params(work_params)
    rescue ActiveRecord::RecordNotFound => ex
      flash.now[:alert] = "Invalid instrument"
      @work = Work.new
      render "create", :status => :bad_request and return
    end
    begin
      @work.save!
    rescue ActiveRecord::ActiveRecordError => ex
      flash.now[:alert] = "Validation failed"
      render "create", :status => :bad_request and return
    end
    flash.now[:notice] = "Work created"
    @works = Work.all
    render "index"
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
