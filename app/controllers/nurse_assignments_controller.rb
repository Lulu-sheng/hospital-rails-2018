require 'date'
class NurseAssignmentsController < ApplicationController
  def create
    patient = Patient.find(nurse_assignment_params[:patient_id])
    @nurse_assignment = @user_nurse.nurse_assignments.build(patient: patient, start_date: Date.today)

    respond_to do |format|
      # if there are no nurse assignments currently in place between the pair
      if (NurseAssignment.where(patient_id: nurse_assignment_params[:patient_id], nurse_id: @user_nurse, end_date: nil).empty? &&
          @nurse_assignment.save)
        format.js { @new_patient_name = patient.name
                    @current_patients = Patient.all 
                    render action: 'update'}
      else
        format.html { flash[:warning] = 'You are already assigned to this patient.'
                      redirect_to patients_path }
      end
    end
  end

  def update
    assignment = NurseAssignment.where(nurse_id: @user_nurse, patient_id: nurse_assignment_params[:patient_id], end_date: nil) 

    respond_to do |format|
      # set the end_date
      if assignment.update(end_date: Date.today)
        format.js {@new_patient_name = nil
                   @current_patients = Patient.all}
      else
        format.html { redirect_to nurses_path, notice: 'Unsuccessfully dropped patient'}
      end
    end
  end

  private

  def nurse_assignment_params
    params.permit(:patient_id)
  end
end
