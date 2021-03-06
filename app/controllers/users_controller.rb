class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :require_user

  helper DateAndTimeHelper

  # GET /users
  # GET /users.json
  def index
    store_listing_referer

    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    store_location
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    # Hack to bypass authlogic password requirements when not requiring
    # password creation in the UI (since it must be reset on activation)
    @user.password = SecureRandom.hex
    @user.password_confirmation = @user.password

    respond_to do |format|
      if @user.save
        @user.send_activation_email

        format.html { redirect_to @user, notice:
                      'User created and activation email sent.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    p = user_params

    # invalidate persistence token if user is deactivated
    deactivated = true if @user.active != p[:active] && p[:active] == "0"

    respond_to do |format|
      if @user.update(p)
        @user.reset_persistence_token! if deactivated

        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to session[:listing_referer] || users_url }
      format.json { head :no_content }
    end

    rescue ActiveRecord::InvalidForeignKey
      flash[:notice] = 'User cannot be deleted because it is associated with at least model in the system.'
      redirect_to action: "index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :phone, :password, :password_confirmation, :active)
    end
end
