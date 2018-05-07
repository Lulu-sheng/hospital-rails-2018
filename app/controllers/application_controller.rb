class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # change this so that you only set_user when
  # you use @user_nurse. Otherwise, don't!
  include CurrentUser
  before_action :set_user
  before_action :authorize

  protected

  def authorize
    # everything is untouchable except for
    # the sessions controller. You must login
    # order to access everything but the login page
    if session[:nurse_id].nil?
      flash[:warning] = 'Please log in'
      redirect_to login_url
    end
  end
end
