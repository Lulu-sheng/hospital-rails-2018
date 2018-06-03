class PatientsController < ApplicationController
  layout "index_layout", except: [:new, :create, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_patient

  def sort
    @current_patients = 
      if params[:nurse_id]
        Nurse.find(params[:nurse_id]).patients.order(name: :asc)
      else
        Patient.all.order(name: :asc)
      end
    render 'index'
  end

  def index
    if params[:set_locale]
      redirect_to patients_url(locale: params[:set_locale])
    end
    if (params[:nurse_id])
      assignments = Patient.joins(:nurse_assignments).where('nurse_assignments.nurse_id': params[:nurse_id])
        .select('patients.*, nurse_assignments.end_date AS end_date')

      @current_patients, @past_patients = assignments.partition { |assignment| assignment.end_date.nil? }
      @past_patients.uniq!
      @is_subsection = true
    else
      @current_patients = Patient.all
      @is_subsection = false
    end
  end

  def new
    @patient = Patient.new
    @doctor_array = get_doctors
  end

  def create
    @patient = Patient.new(patient_params)

    respond_to do |format|
      if @patient.save
        unless params[:email_check].nil?
          MentorConfirmationMailer.assigned(Doctor.find(params[:patient][:doctor_id]), params[:email_text]).deliver_later
        end

        format.html { flash[:success] = 'Patient record was successfully created.'
                      redirect_to patients_path }
        @current_patients = Patient.all
        ActionCable.server.broadcast 'patients', html: render_to_string('patients/index', layout: false)
      else
        logger.error "Invalid parameters for a patient record"
        @doctor_array = get_doctors
        format.html { render :new }
      end
    end
  end

  def show
    @patient = Patient.find(params[:id])
  end

  def destroy
    @patient = Patient.find(params[:id])
    if @patient.nurses.to_a.include? @user_nurse
      @patient.destroy
      respond_to do |format|
        format.html { flash[:success] = 'Patient was successfully removed.'
                      redirect_to patients_url }
        @current_patients = Patient.all
        ActionCable.server.broadcast 'patients', html: render_to_string('patients/index', layout: false)
      end
    else
      respond_to do |format|
        format.html { flash[:warning] = 'You cannot remove a patient that is not under your care' 
                      redirect_to patients_url }
      end
    end
  end

  def information
    patient = Patient.find(params[:id])
    if stale?(patient)
      respond_to do |format|
        format.json { render json: {status: 'SUCCESS', message: 'Loaded patient information', data: patient}, status: :ok }
      end
    end
  end

  private
  def get_doctors
    Doctor.all.to_a.map do |doctor|
      { name: doctor.employee_record.name,
        value: doctor.id,
        is_student: !doctor.mentor_id.nil?
      }
    end
  end

  def invalid_patient
    logger.error "Attempt to access invalid patient #{params[:id]}"
    flash[:warning] = 'Invalid patient'
    redirect_to patients_url
  end

  def patient_params
    params.require(:patient).permit(:name, :emergency_contact, :blood_type,
                                    :doctor_id, :room_id, :'admitted_on(1i)', 
                                    :'admitted_on(2i)', :'admitted_on(3i)')
  end
end

