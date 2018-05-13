require 'test_helper'

class NurseAssignmentControllerTest < ActionDispatch::IntegrationTest
  test "should manage patient (not currently mine)" do
    assert_difference('NurseAssignment.count', 1) do
      post '/nurse_assignments', params: {patient_id: patients(:three).id}, xhr: true 
    end
    assert_match /<li class=\\"patient-highlight/, @response.body
  end

  test "should not manage patient currently mine" do
    assert_difference('NurseAssignment.count', 1) do
      post nurse_assignments_path(patient_id: patients(:three)), xhr: true 
    end
    assert_difference('NurseAssignment.count', 0) do
      post nurse_assignments_path(patient_id: patients(:three)), xhr: true 
    end

    assert_equal flash[:warning], 'You are already assigned to this patient.'
    #assert_select '#Banner23Heading', 'You are already assigned to this patient.'
    #assert_select 'h1.Polaris-DisplayText', 'You are already assigned to this patient.'

  end

  test "should drop patient" do
    put nurse_assignments_path(patient_id: patients(:one)), xhr: true 
    assert_response :success
    assert_match /<div class=\\"Record-Card/, @response.body
  end
end
