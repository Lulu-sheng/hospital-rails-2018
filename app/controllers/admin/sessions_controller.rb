class Admin::SessionsController < Admin::BaseController
  skip_before_action :authorize
  skip_before_action :admin_authorize
  def new
    #it just needs to show the login stuff!
    unless session[:nurse_id].nil?
      redirect_to admin_patients_url
    end
  end

  def create
    nurse = Nurse.find_by(username: params[:username])
    if nurse.try(:authenticate, params[:password]) # checks if user is nil before trying to call
      # authenticate does the decoding of the hashed password
      session[:nurse_id] = nurse.id
      redirect_to admin_patients_url
    else
      flash[:warning] = 'Invalid user/password combination'
      redirect_to admin_login_url
    end
  end

  def destroy
    session[:nurse_id] = nil
    flash[:success] = 'Logged out'
    redirect_to admin_login_url
  end
end
