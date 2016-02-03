class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new
  end

  def create
    @user = User.find_by_smart_case_login_field( params[:username] )
    if @user
      @user.send_password_reset_email
      flash[:notice] = "Instructions to reset your password have been emailed to you."
      redirect_to root_path
    else
      flash.now[:error] = "No user was found with username \"#{ params[:username] }.\""
      render :action => :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.active = true

    # Use @user.save_without_session_maintenance instead if you
    # don't want the user to be signed in automatically.
    if @user.save
      flash[:success] = "Your password was successfully updated"
      redirect_to home_path
    else
      render :action => :edit, locals: { submission_errors: @user.errors }
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Account not found.  This is most likely due to an expired password reset token."
      redirect_to root_url
    end
  end
end
