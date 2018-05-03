module PatientHelper
  def button_to_if(patient, text, path, button, remote, method)
    #if @user_nurse.patients.to_a.include? patient && !NurseAssignment.where(patient_id: patient, nurse_id: @user_nurse, end_date: nil).to_a.nil?
    if !NurseAssignment.where(patient_id: patient, nurse_id: @user_nurse, end_date: nil).empty?
      button_to text, path, class: button, remote: remote, method: method
    end
  end
end
