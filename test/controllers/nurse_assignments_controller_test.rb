require 'test_helper'

class NurseAssignmentControllerTest < ActionDispatch::IntegrationTest
  test "should manage patient (not currently mine)" do
    assert_difference('NurseAssignment.count', 1) do
      post nurse_assignments_path(patient_id: patients(:three)), xhr: true 
    end
    assert_match /<li class=\\"patient-highlight/, @response.body
  end

  test "should not manage patient currently mine" do
    post nurse_assignments_path(patient_id: patients(:three)), xhr: true 
    assert_difference('NurseAssignment.count', 0) do
      post nurse_assignments_path(patient_id: patients(:three)), xhr: true 
    end

    assert_select '#Banner23Heading', 'You are already assigned to this patient.'

  end

  test "should not drop patient (not currently mine)" do
    assert_difference('NurseAssignment.count', 0) do
      put nurse_assignments_path(patient_id: patients(:three)), xhr: true 
    end
    #follow_redirect!
    #assert_select 'p.Polaris-Heading', 'You are already assigned to this patient.'
  end

  test "should drop patient" do
    post nurse_assignments_path(patient_id: patients(:three)), xhr: true 
    post nurse_assignments_path(patient_id: patients(:one)), xhr: true 
    put nurse_assignments_path(patient_id: patients(:three)), xhr: true 

    assert_match /<li class=\\"Polaris-List__Item/, @response.body
    #assert_select 'li.Polaris-List__Item', 1
    #follow_redirect!
    #assert_select 'p.Polaris-Heading', 'You are already assigned to this patient.'
  end
end
