class WorksController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :edit]

  def new
    @work = Work.new
    6.times { @work.parts.build }
    flash.now[:notice] = "Describe your new work"
  end

  def create
    begin
      @work = Work.build_from_params(work_params)
    rescue ActiveRecord::RecordNotFound => ex
      flash.now[:alert] = "Invalid instrument"
      @work = Work.new
      6.times { @work.parts.build }
      render "create", :status => :bad_request and return
    end
    begin
      @work.save!
    rescue ActiveRecord::ActiveRecordError => ex
      if ex.class == ActiveRecord::RecordNotUnique
        flash.now[:alert] = "That title is already taken"
      else
        flash.now[:alert] = "The music could not be added"
      end
      if !@work.parts.any?
        6.times { @work.parts.build }
      end
      render "create", :status => :bad_request and return
    end
    flash.now[:notice] = "Work created"
    @works = Work.all
    render "index"
  end

  def index
    set_recorded_scope
    set_sorting_options
  end

  def vocal
    @works = Work.vocal.distinct
    @current_scope = get_scope
    @path = works_vocal_path
    set_sorting_options
    render "index"
  end

  def instrumental
    @works = Work.instrumental.distinct
    @current_scope = get_scope
    @path = works_instrumental_path
    set_sorting_options
    render "index"
  end

  def show
    @work = Work.find(params[:id])
    @scores = []
    @recordings = []
    @work.formatted_score_links { |s| @scores << s }
    @work.formatted_recording_links { |r| @recordings << r }
  end

  def search
    search_term = Work.connection.quote('%' + params[:search_term] + '%')
    clause = "title like #{search_term}"
    @works = Work.where(clause).distinct
    render "index"
  end

  def edit
    @work = Work.find(params[:id])
  end

  def update
    @work = Work.find(params[:id])
    begin
      empties = []
      work_params.each do |wp|
        if wp[1] == ""
          empties << wp[0]
        end
      end
      @work.update!(work_params.except(*empties))
    rescue ActiveRecord::ActiveRecordError => ex
      flash.now[:alert] = "Edit failed"
      render "edit", :status => :bad_request and return
    end
    flash.now[:notice] = "Work updated"
    @works = Work.all
    render "index"
  end

  def delete
  end

  private
    def work_params
      params.require(:work).permit(:title, :genre_id, :composed_in,
                                  :revised_in, :lyricist, :ascap,
                                  parts_attributes:
                                    [:id, :instrument_id, :quantity])
    end

    def set_recorded_scope
      if params[:scope].present? && params[:scope] == "all"
        @works = Work.all.distinct
        @current_scope = "all"
      else
        @works = Work.recorded.distinct
        @current_scope = get_scope
      end
    end

    def set_sorting_options
      if params[:sort_key].present?
        @current_sort_key = params[:sort_key]
        if params[:order].present?
          trimmed_param = params[:order].sub(/ending/, '')
          @works = @works.order(
            {params[:sort_key].to_sym => trimmed_param.to_sym}
          )
        end
      else
        @current_sort_key = get_sort_key
        @works = @works.sort { |a,b| a.composed_in <=> b.composed_in }
      end
    end
end
