require 'test_helper'

class NursesControllerTest < ActionDispatch::IntegrationTest
  # no need for setup yet, you only have index
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

  test "should get sort" do
    get url_for(controller: 'nurses', action: 'sort')
    assert_response :success
    assert_select 'h2.Polaris-Heading', 'Bella: bella.com'
    #first element that matches
  end

  test "should create nurse" do
    assert_difference ('Nurse.count') do
      post nurses_url, params: {nurse: {'date_of_certification(1i)': '2015', 'date_of_certification(2i)': '01', 'date_of_certification(3i)': '01',
                                        night_shift: true, hours_per_week: 5}}
    end
    #assert_redirected_to nurses_url
  end

end
