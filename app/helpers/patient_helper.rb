module PatientHelper
=begin
  def button_to_if(patient, text, path, button, remote, method)
    unless NurseAssignment.where(patient_id: patient, nurse_id: @user_nurse, end_date: nil).empty?
      button_to text, path, class: button, remote: remote, method: method
    end
  end
=end
end
