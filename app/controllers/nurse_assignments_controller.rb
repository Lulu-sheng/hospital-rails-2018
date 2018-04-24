require 'date'
class NurseAssignmentsController < ApplicationController
  # POST /nurse_assignments
  def create
    patient = Patient.find(params[:patient_id])
    @nurse_assignment = @user_nurse.nurse_assignments.build(patient: patient, start_date: Date.today)
    p @nurse_assignment

    respond_to do |format|
      if @nurse_assignment.save
        format.html { redirect_to patients_path, notice: 'Successfully assigned nurse to patient' }
      else
        format.html { redirect_to nurses_path, notice: 'Nurse to patient assignment was unsuccessfully created.'}
      end
    end
  end
end
