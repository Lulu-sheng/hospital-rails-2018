require 'date'
class Admin::NurseAssignmentsController < Admin::BaseController
  # POST /nurse_assignments/1
  def create
    patient = Patient.find(nurse_assignment_params[:patient_id])
    @nurse_assignment = @user_nurse.nurse_assignments.build(patient: patient, start_date: Date.today)

    respond_to do |format|
      if (NurseAssignment.where(patient_id: nurse_assignment_params[:patient_id], nurse_id: @user_nurse, end_date: nil).empty? &&
          @nurse_assignment.save)
        format.html { flash[:success] = 'Successfully assigned nurse to patient' 
                      redirect_to admin_patients_url, notice: 'Successfully assigned nurse to patient' } # not necessary
        # inside of the block because this is the stuff that is only  associated with the js response
        format.js { @new_patient_name = patient.name
                    @current_patients = Patient.all 
                    render action: 'update'}
      else
        format.html { flash[:warning] = 'You are already assigned to this patient.'
                      redirect_to admin_patients_url }
      end
    end
  end

  # PUT /nurse_assignments/1
  def update
    assignment = NurseAssignment.where(nurse_id: @user_nurse, patient_id: nurse_assignment_params[:patient_id], end_date: nil) 

    respond_to do |format|
      if assignment.update(end_date: Date.today)
        format.html { redirect_to admin_patients_url, notice: 'Successfully assigned nurse to patient' } # not necessary
        format.js {@new_patient_name = nil
                   @current_patients = Patient.all}
      else
        format.html { redirect_to admin_nurses_url, notice: 'Unsuccessfully dropped patient'}
      end
    end
  end

  private

  def nurse_assignment_params
    params.permit(:patient_id)
  end
end
