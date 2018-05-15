class Admin::BaseController < ApplicationController
  before_action :admin_authorize
  def self.local_prefixes
    [controller_path, 'admin']
  end

  def admin_authorize
    if @user_nurse.id != Nurse.first.id
      flash[:warning] = 'Only admin nurses are able to access this action/page'
      redirect_to login_url
    end
  end
end
