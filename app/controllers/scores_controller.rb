class ScoresController < ApplicationController
  before_action :logged_in_user
  def create
    @work = Work.find(params[:work_id])
    @score = @work.scores.build(score_params)
    begin
      @score.save!
    rescue ActiveRecord::RecordInvalid => ex
      render "edit", status: :bad_request and return
    end
    flash[:notice] = "Score created"
    redirect_to work_path(@work)
  end

  def new
    @work = Work.find(params[:work_id])
    @score = @work.scores.new
    render "edit"
  end

  def destroy
    @score = Score.find(params[:id])
    @work = @score.work
    @score.destroy
    flash[:notice] = "Score deleted"
    redirect_to work_path(@work)
  end

  private
    def score_params
      params.require(:score).permit(:work_id, :label, :file_name)
    end
end
