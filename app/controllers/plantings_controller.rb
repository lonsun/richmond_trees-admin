class PlantingsController < ApplicationController
  before_filter :require_user
  
  before_action :set_planting, only: [:show, :edit, :update, :destroy]

  helper DateAndTimeHelper

  # GET /plantings
  # GET /plantings.json
  def index
    @plantings = Planting.joins( :parent_adoption_request ).order( "adoption_requests.street_name, adoption_requests.house_number" )
  
    respond_to do |format|
      format.html
      format.csv { send_data @plantings.to_csv }
    end
  end

  # GET /plantings/1
  # GET /plantings/1.json
  def show
    @maintenance_records = []
    @notes = []

    # get associated maintenance records
    MaintenanceRecord.where( planting_id: @planting.id ).order( :maintenance_date ).reverse_order.find_each do |r|
      @maintenance_records.push( r )
    end

    # get associated notes
    Note.where(planting_id: @planting.id).order( :created_at ).reverse_order.find_each do |n|
      @notes.push( n )
    end
  end

  # GET /plantings/new
  def new
    @planting = Planting.new
  end

  # GET /plantings/1/edit
  def edit
  end

  # POST /plantings
  # POST /plantings.json
  def create
    @planting = Planting.new(planting_params)
    @planting.user_id = current_user.id #created by

    respond_to do |format|
      if @planting.save
        format.html { redirect_to @planting, notice: 'Planting was successfully created.' }
        format.json { render action: 'show', status: :created, location: @planting }
      else
        format.html { render action: 'new' }
        format.json { render json: @planting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plantings/1
  # PATCH/PUT /plantings/1.json
  def update
    respond_to do |format|
      if @planting.update(planting_params)
        format.html { redirect_to @planting, notice: 'Planting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @planting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plantings/1
  # DELETE /plantings/1.json
  def destroy
    @planting.destroy
    respond_to do |format|
      format.html { redirect_to plantings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_planting
      @planting = Planting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def planting_params
      params.require(:planting).permit(:adoption_request_id, :tree_id, :planted_on, :event, :placement, :plant_space_width, :stakes_removed, :user_id)
    end
end
