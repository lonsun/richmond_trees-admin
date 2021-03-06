class NotesController < ApplicationController
  before_filter :require_user

  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :handle_ignored, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
    @planting_id = params[:planting_id] || ""
  end

  # GET /notes/1/edit
  # def edit
  # end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id #created by

    # This is necessary to populate this field in the form when there is a validation error.
    @planting_id = @note.planting_id unless @note.nil?

    respond_to do |format|
      if @note.save
        format.html { redirect_to :controller => 'plantings', :action => 'show', :id => @planting_id, notice: 'Note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @note }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  # def update
  #   respond_to do |format|
  #     if @note.update(note_params)
  #       format.html { redirect_to :controller => 'plantings', :action => 'show', :id => @note.planting_id, notice: 'Note was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @note.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    # mark the record to be ignored by default
    if params.has_key?('hard_delete') && params['hard_delete'] == 'yes'
      @note.destroy
    else
      @note.ignore = true
      @note.save!
    end

    respond_to do |format|
      format.html { redirect_to :controller => 'plantings', :action => 'show',
                    :id => @note.planting_id }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # records marked as ignored should be treated as if they don't exist
    def handle_ignored
      if @note.ignore == true
        raise ActiveRecord::RecordNotFound
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:planting_id, :user_id, :note, :hard_delete)
    end
end
