class InstrumentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update]
  def new
  end

  def create
    begin
    @instrument = Instrument.find_or_create_by!(instrument_params)
    rescue Error => ex
      flash[:alert] = "Error creating instrument: #{ex.message}"
      redirect_to root_url
    end
  end

  def show
    begin
      @instrument = Instrument.find(params[:id])
    rescue ActiveRecord::RecordNotFound => ex
      flash[:alert] = "That instrument was not found"
      redirect_to root_url
    end
  end

  def index
    @instruments = Instrument.all.sort { |a,b| a.rank <=> b.rank }
  end

  def edit
  end

  def update
    @instrument = Instrument.find(params[:id])
    @instrument.update(instrument_params)
    flash[:information] = "Instrument updated"
    render "show"
  end

  private
    def instrument_params
      params.require(:instrument).permit(:name, :rank, :family)
    end

end
