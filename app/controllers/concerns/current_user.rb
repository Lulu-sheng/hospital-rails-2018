module CurrentUser
  private
  def set_user
    @user_nurse = Nurse.find(session[:nurse_id]) 
    # if the session object isn't populated
    # this will throw an error
  rescue ActiveRecord::RecordNotFound
    # if the session object isn't populated, then that means
    # that this is the first time logging in.
    #
    # AUTHENTICATE: if the user is cool and all,
    # get the user_id of logged in user, and populate
    # it into the session hash thing
    @user_nurse = Nurse.first
    # default: create a new user and set it to this person
    session[:nurse_id] = @user_nurse.id
  end
end
