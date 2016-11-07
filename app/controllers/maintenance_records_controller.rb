class MaintenanceRecordsController < ApplicationController
  before_filter :require_user

  before_action :set_maintenance_record, only: [:show, :edit, :update, :destroy]
  before_action :handle_ignored, only: [:show, :edit, :update, :destroy]

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
    @planting_id = params[:planting_id] || ""
  end

  # GET /maintenance_records/1/edit
  def edit
  end

  # POST /maintenance_records
  # POST /maintenance_records.json
  def create
    @maintenance_record = MaintenanceRecord.new(maintenance_record_params)
    @maintenance_record.user_id = current_user.id #created by

    # This is necessary to populate this field in the form when there is a validation error.
    @planting_id = @maintenance_record.planting_id unless @maintenance_record.nil?

    respond_to do |format|
      if @maintenance_record.save
        @maintenance_record.planting.stakes_removed = params[:mark_stakes_removed]
        @maintenance_record.planting.save

        if ! params[:planting_note].empty?
          note = Note.new({
            planting_id: @planting_id,
            user_id: current_user.id,
            note: params[:planting_note]
          })

          note.save
        end

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
    # this is necessary to update reason codes correctly if none are checked on the frontend
    params[:maintenance_record][:reason_codes] = [] if params[:maintenance_record][:reason_codes].nil?

    respond_to do |format|
      if @maintenance_record.update(maintenance_record_params)
        @maintenance_record.planting.stakes_removed = params[:mark_stakes_removed]
        @maintenance_record.planting.save

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
    # mark the record to be ignored by default
    if params.has_key?('hard_delete') && params['hard_delete'] == 'yes'
      @maintenance_record.destroy
    else
      @maintenance_record.ignore = true
      @maintenance_record.save!
    end

    respond_to do |format|
      format.html { redirect_to :controller => 'plantings', :action => 'show',
                    :id => @maintenance_record.planting_id }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_record
      @maintenance_record = MaintenanceRecord.find(params[:id])
    end

    # records marked as ignored should be treated as if they don't exist
    def handle_ignored
      if @maintenance_record.ignore == true
        raise ActiveRecord::RecordNotFound
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def maintenance_record_params
      params.require(:maintenance_record)
        .permit(:maintenance_date, :status_code, { :reason_codes => [] },
                :diameter_breast_height, :planting_id, :user_id, :mark_stakes_removed,
                :hard_delete, :planting_note)
    end
end
