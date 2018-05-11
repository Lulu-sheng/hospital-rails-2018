class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
    if Nurse.count == 0
      redirect_to new_nurse_url
    elsif !session[:nurse_id].nil?
      redirect_to patients_url
    end
  end

  def create
    nurse = Nurse.find_by(username: params[:username])
    if nurse.try(:authenticate, params[:password]) # checks if user is nil before trying to call
      # authenticate does the decoding of the hashed password
      session[:nurse_id] = nurse.id
      redirect_to patients_url
    else
      flash[:warning] = 'Invalid user/password combination'
      redirect_to login_url
    end
  end

  def destroy
    session[:nurse_id] = nil
    flash[:success] = 'Logged out'
    redirect_to login_url
  end
end
