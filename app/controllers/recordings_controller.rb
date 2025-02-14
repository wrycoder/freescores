class RecordingsController < ApplicationController
  before_action :logged_in_user
  def create
    @work = Work.find(params[:work_id])
    @recording = @work.recordings.build(recording_params)
    begin
      @recording.save!
    rescue ActiveRecord::RecordInvalid => ex
      render "edit", status: :bad_request and return
    end
    flash[:notice] = "Recording created"
    redirect_to work_path(@work)
  end

  def new
    @work = Work.find(params[:work_id])
    @recording = @work.recordings.new
    render "edit"
  end

  def destroy
    @recording = Recording.find(params[:id])
    @work = @recording.work
    @recording.destroy
    flash[:notice] = "Recording deleted"
    redirect_to work_path(@work)
  end

  private
    def recording_params
      params.require(:recording).permit(:work_id, :label, :file_name)
    end
end
