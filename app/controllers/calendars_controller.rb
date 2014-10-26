class CalendarsController < ApplicationController
  respond_to :json
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_from_token!

  def my
    @calendars = current_user.google_calendars
    respond_with @calendars, render: 'index'
  end


  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = GoogleCalendar.all
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
  end

  # GET /calendars/new
  def new
    @calendar = GoogleCalendar.new
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = current_user.google_calendars.new(calendar_params)

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to calendar_path(@calendar), notice: 'GoogleCalendar was successfully created.' }
        format.json { render :show, status: :created, location: calendar_path(@calendar) }
      else
        format.html { render :new }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    respond_to do |format|
      if @calendar.update(calendar_params)
        format.html { redirect_to calendar_path(@calendar), notice: 'GoogleCalendar was successfully updated.' }
        format.json { render :show, status: :ok, location: calendar_path(@calendar) }
      else
        format.html { render :edit }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'GoogleCalendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = GoogleCalendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:ext_id)
    end
end
