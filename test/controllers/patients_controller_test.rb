require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @patientA = patients(:three)
  end

  test "should get overall sort" do
    get sort_patients_url
    assert_response :success
  end

  test "should get index" do
    get patients_url
    assert_response :success
    assert_select 'h1', 'Patients'
    assert_select 'div.Record-Card', 3
  end

  test "should get subset of patients with partition" do
    get nurse_patients_path(nurse_id: nurses(:one))
    assert_response :success
    assert_select 'h3', 2
    assert_select 'h1', 'Patients'
  end

  test "should get subset of patients without partition" do
    get nurse_patients_path(nurse_id: nurses(:two))
    assert_response :success
    assert_select 'h3', 'Current Patients'
    assert_select 'h1', 'Patients'
  end

  test "should get new (form)" do
    get new_patient_url
    assert_response :success
    assert_select 'form', true
  end

  test "should create patient general" do
    assert_difference 'Patient.count', 1 do
      post patients_url, params: { patient: { name: 'James Turtle', 
                                              emergency_contact: 'Helen Turtle', 
                                              blood_type: 'B', 
                                              doctor_id: doctors(:bob).id, 
                                              room_id: rooms(:two).id,
                                              'admitted_on(1i)': '2016',
                                              'admitted_on(2i)': '5',
                                              'admitted_on(3i)': '13'},
                                              email_text: ''}
    end
    follow_redirect!
    assert_select 'p.Polaris-Heading', 'Patient record was successfully created.' 
  end

  test "should display errors faulty create" do
    assert_difference 'Patient.count', 0 do
      post patients_url, params: { patient: { name: '', 
                                              emergency_contact: '', 
                                              blood_type: '', 
                                              doctor_id: nil,
                                              room_id: nil,
                                              'admitted_on(1i)': '',
                                              'admitted_on(2i)': '',
                                              'admitted_on(3i)': ''},
                                              email_text: ''}
    end
    assert_select 'p.Polaris-Heading', '7 errors prohibited this patient from being saved'
  end

  test "should create patient under my care" do
     assert_difference 'Patient.count', 1 do
       post nurse_patients_url(nurse_id: nurses(:one)), 
         params: { patient: { name: 'James Turtle', 
                              emergency_contact: 'Helen Turtle', 
                              blood_type: 'B', 
                              doctor_id: doctors(:bob).id, 
                              room_id: rooms(:two).id,
                              'admitted_on(1i)': '2016',
                              'admitted_on(2i)': '5',
                              'admitted_on(3i)': '13'},
                              email_text: ''}
     end
     follow_redirect!
     assert_select 'p.Polaris-Heading', 'Patient record was successfully created.' 
     get nurse_patients_path(nurse_id: nurses(:one))
     assert_select '.Record-Card', 3
  end

  test "should not create patient not under my care" do
    get new_nurse_patient_url(nurse_id: nurses(:two))
    #follow_redirect!
    #assert_equal flash[:warning], 'You can\'t assign patients to other nurses other than yourself'
  end

  test "should show specific patient" do
    get patient_url(@patientA)
    assert_response :success

    assert_select 'h1.Polaris-DisplayText', "Patient ##{@patientA.id}: #{@patientA.name}"
  end

  test "should flash invalid patient show" do
    get '/patients/0'
    assert_response :redirect
    assert_equal flash[:warning], 'Invalid patient'
  end

  test "should not destroy patient not under my care" do
    delete patient_url(patients(:three))
    assert_response :redirect

    follow_redirect!
    assert_select 'p.Polaris-Heading', 'You cannot remove a patient that is not under your care' 
  end

  test "should destroy patient under my care" do
    delete patient_url(patients(:one))
    follow_redirect!
    assert_equal flash[:success], 'Patient was successfully removed.'
  end
end

