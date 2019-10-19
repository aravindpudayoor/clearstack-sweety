class GlucoseLevelsController < ApplicationController
  before_action :authenticate_user!, :set_user
  # before_action :check_daily_limit, only: [:create]

  ## Below action will fetch glucose levels of a particular user 
  ## calculating min, max and avegrage of reading
  # GET /glucose_levels
  def index
    @glucose_levels = @user.glucose_levels.search_and_order(params[:end_date], params[:report])
    value_arr = @glucose_levels.pluck(:value)
    @min = value_arr.min
    @max = value_arr.max
    @avg = value_arr.blank? ? nil : value_arr.inject(:+) / value_arr.size
  end

  ## Below action will render the glucose level data entry form
  ##
  # GET /glucose_levels/new
  def new
    @glucose_level = GlucoseLevel.new
  end

  ## Below action will create glucose level data to the database, if daily limit condition passing
  ##
  # POST /glucose_levels
  def create
    @glucose_level = GlucoseLevel.new(glucose_level_params)
    respond_to do |format|
      @glucose_level.valid?
      if @glucose_level.errors.blank?
        @glucose_level.save
        format.html { redirect_to glucose_levels_path, notice: 'Glucose level was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  ## Setting user
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def glucose_level_params
    params.require(:glucose_level).permit(:value, :user_id)
  end

  ## Below action make will sure that there are no more than specified(here 4) entries on a given day.
  def check_daily_limit
    # unless @user.glucose_levels.where("DATE(created_at) = ?", DateTime.now.to_date).count < GlucoseLevel::DAILY_LIMIT
    unless @user.glucose_levels.of_date(Date.today).count < GlucoseLevel::DAILY_LIMIT
      respond_to do |format|
        format.html { redirect_to glucose_levels_path, alert: 'Daily Limit exceeds, You cant create a new entry today' } 
      end
    end
  end
end
