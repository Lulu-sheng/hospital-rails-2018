class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
    # my attempt to create an initial form
    if Nurse.count == 0
      redirect_to new_admin_nurse_url
    elsif !session[:nurse_id].nil?
      redirect_to patients_url
    end
  end

  def create
    nurse = Nurse.find_by(username: params[:username])
    if nurse.try(:authenticate, params[:password]) 
      session[:nurse_id] = nurse.id
      if (Nurse.first.id.eql?(nurse.id))
        redirect_to admin_patients_url
      else
        redirect_to patients_url
      end
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
