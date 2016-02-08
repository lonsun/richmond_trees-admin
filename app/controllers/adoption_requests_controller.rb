class AdoptionRequestsController < ApplicationController
  before_filter :require_user

  before_action :set_adoption_request, only: [:show, :edit, :update, :destroy]
  before_action :handle_ignored, only: [:show, :edit, :update, :destroy]

  helper DateAndTimeHelper

  # GET /adoption_requests
  # GET /adoption_requests.json
  def index
    store_listing_referer

    include_completed = params[:adoption_request][:include_completed] unless params[:adoption_request].nil?

    if include_completed == "1"
      @adoption_requests = AdoptionRequest.all
      @include_completed_checked = "checked"
    else
      @adoption_requests = AdoptionRequest.all.where( :completed => false )
      @include_completed_checked = ""
    end
  end

  # GET /adoption_requests/1
  # GET /adoption_requests/1.json
  def show
  end

  # GET /adoption_requests/new
  def new
    @adoption_request = AdoptionRequest.new
  end

  # GET /adoption_requests/1/edit
  def edit
  end

  # POST /adoption_requests
  # POST /adoption_requests.json
  def create
    @adoption_request = AdoptionRequest.new(adoption_request_params)
    @adoption_request.user_id = current_user.id #created by

    respond_to do |format|
      if @adoption_request.save
        format.html { redirect_to @adoption_request, notice: 'Adoption request was successfully created.' }
        format.json { render action: 'show', status: :created, location: @adoption_request }
      else
        format.html { render action: 'new' }
        format.json { render json: @adoption_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adoption_requests/1
  # PATCH/PUT /adoption_requests/1.json
  def update
    respond_to do |format|
      if @adoption_request.update(adoption_request_params)
        format.html { redirect_to @adoption_request, notice: 'Adoption request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @adoption_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adoption_requests/1
  # DELETE /adoption_requests/1.json
  def destroy
    # mark the record to be ignored by default
    if params.has_key?('hard_delete') && params['hard_delete'] == 'yes'
      @adoption_request.destroy
    else
      @adoption_request.ignore = true
      @adoption_request.save!
    end

    respond_to do |format|
      format.html { redirect_to session[:listing_referer] || adoption_requests_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adoption_request
      @adoption_request = AdoptionRequest.find(params[:id])
    end

    # records marked as ignored should be treated as if they don't exist
    def handle_ignored
      if @adoption_request.ignore == true
        raise ActiveRecord::RecordNotFound
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adoption_request_params
      params.require(:adoption_request).permit( :user_id, :tree_id, :owner_first_name, :owner_last_name,
        :owner_email, :owner_phone, :house_number, :street_name, :city, :state, :zip_code, :spanish_speaker,
        :room_for_tree, :concrete_removal, :wires, :source, :received_on, :contacted_on,
        :form_sent_to_cor_on, :site_assessed_on, :number_of_trees, :plant_space_width, :note,
        :completed, :include_completed, :zone_id, :hard_delete )
    end
end
