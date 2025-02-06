class LinerNotesController < ApplicationController
  before_action :logged_in_user

  def new
    begin
      @work = Work.find(params[:work_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Invalid work"
      redirect_to works_path and return
    end
    @liner_note = LinerNote.new(work_id: @work.id) 
    render "edit", :status => :ok
  end

  def create
    @liner_note = LinerNote.new(liner_note_params)
    begin
      @liner_note.save!
    rescue ActiveRecord::Error => ex
      flash.now[:alert] = "#{ex.message}"
      render "edit", :status => :bad_request and return
    end
    flash[:notice] = "Note added"
    @work = Work.find(@liner_note.work_id)
    redirect_to work_path(@work)
  end

  def edit
    @work = Work.find(params[:id])
    @liner_note = LinerNote.find_by_work_id(@work.id)
  end

  def update
    @liner_note = LinerNote.find(params[:id])
    @liner_note.update(note: liner_note_params[:note])
    @work = Work.find(@liner_note.work_id)
    flash[:notice] = "Liner Note updated"
    redirect_to work_path(@work)
  end

  def show
  end

  private
    def liner_note_params
      params.require(:liner_note).permit(:work_id, :note)
    end
end
