require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @patientA = patients(:three)
  end

  test "should get overall sort" do
    get url_for(controller: 'patients', action: 'sort')
    assert_response :success
    #assert_select 'h2.Polaris-Heading', "#{@patientA.name}: r.#{@patientA.room.number}"
  end

  test "should get specific sort" do
  end

  test "should get index" do
    get patients_url
    assert_response :success
    assert_select 'h1', 'Patients'
    assert_select 'div.Record-Card', 3
  end

  test "should get new (form)" do
    get new_patient_url
    assert_response :success
    assert_select 'form', true
  end

  test "should create patient general" do
    assert_difference 'Patient.count', 1 do
      post patients_url, params: { patient: { name: 'James Turtle', emergency_contact: 'Helen Turtle', blood_type: 'A', doctor: doctors(:bob).id, room: rooms(:two).number}}
    end
    assert_response :redirect
    follow_redirect!
    assert_select 'p.Polaris-Heading', 'Patient was successfully created.' 
  end

  test "should create patient under me" do
  end

  test "should NOT create invalid patient" do
    assert_difference 'Patient.count', 0 do
      post patients_url, params: { patient: { name: @patientA.name, emergency_contact: @patientA.emergency_contact, blood_type: @patientA.blood_type, doctor: @patientA.doctor_id, room: @patientA.room_id}}
    end

    assert_response :redirect
    follow_redirect!
    assert_select 'p.Polaris-Heading', 'Patient record was unsuccessfully created.' 
  end

  test "should show specific patient" do
    get patient_url(@patientA)
    assert_response :success

    assert_select 'h1.Polaris-DisplayText', "Patient ##{@patientA.id}: #{@patientA.name}"
  end

  test "should flash invalid patient show" do
    get '/patients/0'
    assert_response :redirect
    #assert_select 'p.Polaris-Heading', 'Patient record was unsuccessfully created.' 
  end

  test "should not destroy patient not under my care" do
    delete patient_url(patients(:one))
    assert_response :redirect

    follow_redirect!
    assert_select 'p.Polaris-Heading', 'You cannot remove a patient that is not under your care' 
  end

  test "should destory patient under my care" do
  end
end

