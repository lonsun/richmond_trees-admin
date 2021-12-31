class UserSessionsController < ApplicationController
  # before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  # log in the user or send them back to login page.
  def create
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      redirect_to home_path
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end

  def user_session_params
    params.require(:user_session).permit(:username, :password, :password_confirmation)
  end
end
