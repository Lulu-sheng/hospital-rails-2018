require 'test_helper'

class NursesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nurses_url
    assert_response :success
    assert_select 'h1', 'Nurses'
    assert_select 'div.Record-Card', 3
  end

  test "should get new" do
    get new_nurse_url
    assert_response :success
  end

  test "should get edit" do
    get edit_nurse_url(nurses(:one))
    assert_response :success
  end

  test "should update nurse (yourself)" do
    patch nurse_url(nurses(:one)), params: {employee_record: {name: 'Nora', email: 'yahoo.com', salary: 2321},
                                            nurse: {'date_of_certification(1i)': '2015', 'date_of_certification(2i)': '01', 
                                                    'date_of_certification(3i)': '01', night_shift: true, hours_per_week: 5, 
                                                    username: 'yello', password: 'secret', password_confirmation: 'secret'}}
    assert_redirected_to nurses_url(locale: 'en')
  end

  test "should get sort" do
    get url_for(controller: 'nurses', action: 'sort')
    assert_response :success
    assert_select 'h2.Polaris-Heading', 'Bella: bella.com'
    #first element that matches
  end

  test "should create nurse" do
    assert_difference ('Nurse.count') do
      post nurses_url, params: {employee_record: {name: 'Georgia', email: 'georgia@gmail.com', salary: 2321},
                                nurse: {'date_of_certification(1i)': '2015', 'date_of_certification(2i)': '01', 'date_of_certification(3i)': '01',
                                        night_shift: true, hours_per_week: 5, username: 'hello', password: 'secret', password_confirmation: 'secret'}}
    end
    follow_redirect!
    assert_select '#Banner23Heading p', 'Nurse was successfully created'
  end

  test "should destroy nurse" do
    assert_difference 'Nurse.count', -1 do
      delete nurse_path(nurses(:three))
    end

    follow_redirect!
    assert_equal flash[:success], 'Nurse was successfully removed from the system'
  end

  test "should not allow last nurse deleted" do
    delete nurse_path(nurses(:three))
    delete nurse_path(nurses(:two))
    delete nurse_path(nurses(:one))
    follow_redirect!
    assert_equal flash[:warning], 'Can\'t delete last nurse'
  end

  test "should logout when remove yourself" do
    delete nurse_path(nurses(:one))
    follow_redirect!
    assert_equal flash[:warning], 'Please log in'
  end

  test "display errors faulty create" do
    assert_difference 'Nurse.count', 0 do
      post admin_nurses_url, params: {employee_record: {name: '', email: '', salary: nil},
                                nurse: {'date_of_certification(1i)': '', 'date_of_certification(2i)': '', 'date_of_certification(3i)': '',
                                        night_shift: nil, hours_per_week: nil, username: '', password: '', password_confirmation: ''}}
    end
    assert_select 'p.Polaris-Heading', '10 errors prohibited this nurse from being saved:'

  end
end
