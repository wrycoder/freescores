class InstrumentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update]
  def new
    flash.now[:notice] = "Define the new instrument's properties"
  end

  def create
    begin
      @instrument = Instrument.create!(instrument_params)
    rescue ActiveRecord::ActiveRecordError => ex
      @instrument = Instrument.new(instrument_params)
      flash.now[:alert] = "#{ex.message}"
      render "create" and return
    end
    flash.now[:notice] = "Instrument created"
    @instruments = Instrument.all
    render "index"
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
    flash.now[:notice] = "Instrument updated"
    render "show"
  end

  private
    def instrument_params
      params.require(:instrument).permit(:name, :rank, :family)
    end

end
