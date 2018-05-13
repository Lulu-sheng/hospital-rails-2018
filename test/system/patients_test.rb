require "application_system_test_case"

class PatientsTest < ApplicationSystemTestCase
  def setup
    visit login_url
    fill_in 'username', with: nurses(:one).username
    fill_in 'password', with: 'secret'
    click_on "Login"
  end

  test "react component dynamic select" do
    visit patients_url

    click_link "Add New Record"

    #page.driver.browser.navigate.refresh
    
    fill_in 'patient[name]', with: 'William Turner', wait: 5
    fill_in 'patient[emergency_contact]', with: 'Jose Guava'
    fill_in 'patient[blood_type]', with: 'AB'

    select 'Jennifer', from: 'patient[doctor_id]' 
    assert_no_selector '.Polaris-Choice'

    select 'Bob', from: 'patient[doctor_id]'
    assert_selector '.Polaris-Choice'
    assert_no_selector '.Polaris-TextField Polaris-TextField--multiline'

    find(".Polaris-Checkbox").click
    assert_selector '.Polaris-TextField--multiline'
    #https://github.com/thoughtbot/capybara-webkit/issues/629
    click_on "Create patient"

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["lulu.sheng1418@gmail.com"], mail.to 
    assert_equal 'Lulu Sheng lulu.sheng1418@gmail.com', mail[:from].value 
    assert_equal "Your Student, Bob, Has Been Assigned To A Patient", mail.subject
  end
end
