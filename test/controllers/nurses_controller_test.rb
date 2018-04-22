require 'test_helper'

class NursesControllerTest < ActionDispatch::IntegrationTest
  # no need for setup yet, you only have index
  test "should get index" do
    get nurses_url
    assert_response :success
    assert_select 'div.Query-Section', 3
    assert_select 'h1', 'Nurses'
    assert_select 'div.Record-Card', 3
  end

  test "should get new" do
    get new_nurse_url
    assert_response :success
  end

  test "should get sort" do
    get url_for('https://hospital-management.myshopify.io/nurses/sort')
    assert_response :success
    assert_select 'h2.Polaris-Heading', 'Bella: bella.com'
    #first element that matches
  end
end
