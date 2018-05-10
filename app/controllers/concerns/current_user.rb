module CurrentUser
  private
  def set_user
    @user_nurse = Nurse.find(session[:nurse_id]) 
  rescue ActiveRecord::RecordNotFound
  end
end
