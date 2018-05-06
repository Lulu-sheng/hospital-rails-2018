require "application_system_test_case"

class PatientsTest < ApplicationSystemTestCase
  test "react component dynamic select" do
    visit patients_url

    click_link "Add New Record"
    #find("a[href='#{new_patient_url}']").click

    page.driver.browser.navigate.refresh

    select 'Jennifer', from: 'patient[doctor_id]', wait: 10
    assert_no_selector '.Polaris-Choice'

    select 'Bob', from: 'patient[doctor_id]'
    assert_selector '.Polaris-Choice'
    assert_no_selector '.Polaris-TextField Polaris-TextField--multiline'

    #check 'email_check', wait: 5
    #assert_selector '.Polaris-TextField Polaris-TextField--multiline'
    #https://github.com/thoughtbot/capybara-webkit/issues/629
  end
end
