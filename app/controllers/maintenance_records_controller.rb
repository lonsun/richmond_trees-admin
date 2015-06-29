class MaintenanceRecordsController < ApplicationController
  before_action :set_maintenance_record, only: [:show, :edit, :update, :destroy]

  # GET /maintenance_records
  # GET /maintenance_records.json
  def index
    @maintenance_records = MaintenanceRecord.all
  end

  # GET /maintenance_records/1
  # GET /maintenance_records/1.json
  def show
  end

  # GET /maintenance_records/new
  def new
    @maintenance_record = MaintenanceRecord.new
    @planting_id = params[:planting_id]
  end

  # GET /maintenance_records/1/edit
  def edit
  end

  # POST /maintenance_records
  # POST /maintenance_records.json
  def create
    @maintenance_record = MaintenanceRecord.new(maintenance_record_params)
    # This is necessary to populate this field in the form when there is a validation error.
    @planting_id = @maintenance_record.planting_id unless @maintenance_record.nil?

    respond_to do |format|
      if @maintenance_record.save
        format.html { redirect_to :controller => 'plantings', :action => 'show', :id => @planting_id, notice: 'Maintenance record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @maintenance_record }
      else
        format.html { render action: 'new' }
        format.json { render json: @maintenance_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_records/1
  # PATCH/PUT /maintenance_records/1.json
  def update
    respond_to do |format|
      if @maintenance_record.update(maintenance_record_params)
        format.html { redirect_to :controller => 'plantings', :action => 'show', :id => @maintenance_record.planting_id, notice: 'Maintenance record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @maintenance_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maintenance_records/1
  # DELETE /maintenance_records/1.json
  def destroy
    @maintenance_record.destroy
    respond_to do |format|
      format.html { redirect_to :controller => 'plantings', :action => 'show', :id => @maintenance_record.planting_id }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_record
      @maintenance_record = MaintenanceRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maintenance_record_params
      params.require(:maintenance_record).permit(:maintenance_date, :status_code, :reason_codes, {:reason_codes => []}, :diameter_breast_height, :planting_id)
    end

    def validate_id?(id)
      true if id =~ /[0-9]{1,10}/
      false
    end
end
