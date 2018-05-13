require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should login" do
    nurse = nurses(:one)
    post login_url, params: { username: nurse.username, password: 'secret' } 
    assert_redirected_to patients_url(locale: 'en')
    assert_equal nurse.id, session[:nurse_id]
  end

  test "should fail login" do
    delete logout_url
    nurse = nurses(:one)
    post login_url, params: { username: nurse.username, password: 'wrong' } 
    assert_redirected_to login_url(locale: 'en')
    assert_nil session[:nurse_id]
    assert_equal flash[:warning], 'Invalid user/password combination'
  end

  test "should logout" do
    delete logout_url 
    assert_redirected_to login_url(locale: 'en')
    assert_equal flash[:success], 'Logged out'
  end

  test "should get login" do
    get login_url
    assert_response :redirect
  end

  test "should redirect to login if not authorized" do
    delete logout_url
    get nurses_url
    assert_redirected_to login_url(locale: 'en')
    assert_equal flash[:warning], 'Please log in'
  end
end
