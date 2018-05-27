require "application_system_test_case"

class NewNurseTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  def setup
    visit login_url
    fill_in 'username', with: nurses(:one).username
    fill_in 'password', with: 'secret'
    click_on "Login"
  end

  test "add new nurse" do
    visit admin_nurses_url
    take_screenshot
    click_link "Add New Record"
    fill_in 'employee_record[name]', with: 'Freya'
    fill_in 'employee_record[email]', with: 'lulu.sheng@hotmail.com'
    fill_in 'employee_record[salary]', with: '10000'
    fill_in 'nurse[hours_per_week]', with: '10'
    fill_in 'nurse[username]', with: 'freya'
    fill_in 'nurse[password]', with: 'zhangster'
    fill_in 'nurse[password_confirmation]', with: 'zhangster'

    perform_enqueued_jobs do
      click_on "Create Nurse"
    end

    click_on "Logout"

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["lulu.sheng@hotmail.com"], mail.to 
    assert_equal 'Lulu Sheng lulu.sheng1418@gmail.com', mail[:from].value 
    assert_equal "Welcome To The Hospital, Freya", mail.subject


    visit login_url
    fill_in 'username', with: 'freya'
    fill_in 'password', with: 'zhangster'
    click_on "Login"

    visit nurses_url
    click_on 'Edit Record'
    fill_in 'employee_record[email]', with: 'william.lu@shopify.com', wait: 5
    fill_in 'nurse[password]', with: 'secret'
    fill_in 'nurse[password_confirmation]', with: 'secret'
    perform_enqueued_jobs do
      click_on 'Update Nurse'
    end

    current_gravatar = Nurse.find_by(username: 'freya').employee_record.gravatar
    assert_not_equal current_gravatar, "https://www.gravatar.com/avatar/d69ab4fb9bb28c0527e972273614f585"
    assert_equal current_gravatar, "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest Nurse.find_by(username: 'freya').employee_record.email}"
  end

end
