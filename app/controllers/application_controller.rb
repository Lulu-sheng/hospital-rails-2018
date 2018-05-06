class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # change this so that you only set_user when
  # you use @user_nurse. Otherwise, don't!
  include CurrentUser
  before_action :set_user
end
