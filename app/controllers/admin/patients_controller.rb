class Admin::PatientsController < Admin::BaseController
  layout 'admin/layouts/index_layout', only: [:index, :sort]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_patient

  def sort
    @current_patients = Patient.all.order(name: :asc)
    render :index
  end

  def index
    # refactor this into locales controller
    if params[:set_locale]
      redirect_to admin_patients_url(locale: params[:set_locale])
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

    @url =
      if params[:nurse_id]
        admin_nurse_patients_path
      else
        admin_patients_path
      end
  end

  def create
    @patient = Patient.new(patient_params)

    if params[:nurse_id]
      nurse_assignment = Nurse.find(params[:nurse_id]).nurse_assignments.build(patient: @patient, start_date: Date.today)
    end

    respond_to do |format|
      if @patient.save && (params[:nurse_id]? nurse_assignment.save : true)
        unless params[:email_check].nil?
          MentorConfirmationMailer.assigned(Doctor.find(params[:patient][:doctor_id]), params[:email_text]).deliver_later
        end

        format.html { flash[:success] = 'Patient record was successfully created.'
                      redirect_to admin_patients_url }

        @current_patients = Patient.all
        ActionCable.server.broadcast 'patients', html: render_to_string('admin/patients/index', layout: false)
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
    patient = Patient.find(params[:id])
    patient.destroy
    respond_to do |format|
      format.html { flash[:success] = 'Patient was successfully removed.'
                    redirect_to admin_patients_url }
      @current_patients = Patient.all
      ActionCable.server.broadcast 'patients', html: render_to_string('admin/patients/index', layout: false)
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
    redirect_to admin_patients_url
  end

  def patient_params
    params.require(:patient).permit(:name, :emergency_contact, :blood_type,
                                    :doctor_id, :room_id, :'admitted_on(1i)', 
                                    :'admitted_on(2i)', :'admitted_on(3i)')
  end
end
