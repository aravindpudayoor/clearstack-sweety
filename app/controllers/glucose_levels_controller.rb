class GlucoseLevelsController < ApplicationController
  before_action :authenticate_user!, :set_user
  before_action :set_glucose_level, only: [:show, :edit, :update, :destroy]
  before_action :check_daily_limit, only: [:create]

  # GET /glucose_levels
  # GET /glucose_levels.json
  ## Fetching glucose levels of a particular user and calculating min, max and avegrage of reading
  def index
    @glucose_levels = @user.glucose_levels.search_and_order(params[:end_date], params[:report])
    value_arr = @glucose_levels.pluck(:value)
    @min = value_arr.min
    @max = value_arr.max
    @avg = value_arr.blank? ? nil : value_arr.inject(:+) / value_arr.size
  end

  # # GET /glucose_levels/1
  # # GET /glucose_levels/1.json
  # def show
  # end

  # GET /glucose_levels/new
  def new
    @glucose_level = GlucoseLevel.new
  end

  # GET /glucose_levels/1/edit
  # def edit
  # end

  # POST /glucose_levels
  # POST /glucose_levels.json
  def create
    @glucose_level = GlucoseLevel.new(glucose_level_params)

    respond_to do |format|
      if @glucose_level.save
        format.html { redirect_to glucose_levels_path, notice: 'Glucose level was successfully created.' }
        format.json { render :show, status: :created, location: @glucose_level }
      else
        format.html { render :new }
        format.json { render json: @glucose_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /glucose_levels/1
  # PATCH/PUT /glucose_levels/1.json
  # def update
  #   respond_to do |format|
  #     if @glucose_level.update(glucose_level_params)
  #       format.html { redirect_to glucose_levels_path, notice: 'Glucose level was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @glucose_level }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @glucose_level.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /glucose_levels/1
  # # DELETE /glucose_levels/1.json
  # def destroy
  #   @glucose_level.destroy
  #   respond_to do |format|
  #     format.html { redirect_to glucose_levels_url, notice: 'Glucose level was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  ## setting glucose level
  def set_glucose_level
    @glucose_level = GlucoseLevel.find(params[:id])
  end

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
    unless @user.glucose_levels.where("DATE(created_at) = ?", DateTime.now.to_date).count < GlucoseLevel::DAILY_LIMIT
      respond_to do |format|
        format.html { redirect_to glucose_levels_path, error: 'Daily Limit exceeds, You cant create a new entry today' } 
      end
    end
  end
end
