class TreesController < ApplicationController
  before_action :set_tree, only: [:show, :edit, :update, :destroy]
  before_filter :require_user

  # GET /trees
  # GET /trees.json
  def index
    store_listing_referer

    @trees = Tree.all.order( "common_name" )
  end

  # GET /trees/1
  # GET /trees/1.json
  def show
  end

  # GET /trees/new
  def new
    @tree = Tree.new
  end

  # GET /trees/1/edit
  def edit
  end

  # POST /trees
  # POST /trees.json
  def create
    @tree = Tree.new(tree_params)
    @tree.user_id = current_user.id #created by

    respond_to do |format|
      if @tree.save
        format.html { redirect_to @tree, notice: 'Tree was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tree }
      else
        format.html { render action: 'new' }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trees/1
  # PATCH/PUT /trees/1.json
  def update
    respond_to do |format|
      if @tree.update(tree_params)
        format.html { redirect_to @tree, notice: 'Tree was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1
  # DELETE /trees/1.json
  def destroy
    @tree.destroy
    respond_to do |format|
      format.html { redirect_to session[:listing_referer] || trees_url }
      format.json { head :no_content }
    end

    rescue ActiveRecord::InvalidForeignKey
      flash[:notice] = 'Tree cannot be deleted because it is assigned to at least one planting.'
      redirect_to action: "index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree
      @tree = Tree.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tree_params
      params.require(:tree).permit(:common_name, :scientific_name, :family_name, :user_id)
    end
end
