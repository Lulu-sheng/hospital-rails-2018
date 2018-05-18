class Admin::PatientsController < Admin::BaseController
  layout :resolve_layout
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_patient

  def sort
    @current_patients = Patient.all.order(name: :asc)
    render :index
  end

  def index
    if params[:set_locale]
      redirect_to admin_patients_url(locale: params[:set_locale])
    end
    if (params[:nurse_id])
      @assignments = NurseAssignment.joins(:patient).where(nurse_id: params[:nurse_id])
      @assignments = @assignments.partition { |assignment| assignment.end_date.nil? }

      current_patients = []
      past_patients = []

      @assignments[0].each do |assignment|
        current_patients << assignment.patient_id
      end

      @assignments[1].each do |assignment|
        past_patients << assignment.patient_id
      end

      @current_patients = Patient.where(id: current_patients)
      @past_patients = Patient.where(id: past_patients)
      @is_not_subsection = false

    else
      @current_patients = Patient.all
      @is_not_subsection = true
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

    unless params[:email_check].nil?
      @doctor_assigned = Doctor.find(params[:patient][:doctor_id])
    end

    if params[:nurse_id]
      @nurse_assignment = Nurse.find(params[:nurse_id]).nurse_assignments.build(patient: @patient, start_date: Date.today)
    end

    respond_to do |format|
      if @patient.save && (params[:nurse_id]? @nurse_assignment.save : true)
        unless params[:email_check].nil?
          MentorConfirmationMailer.assigned(@doctor_assigned, params[:email_text]).deliver_later
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
    @patient = Patient.find(params[:id])
    @patient.destroy
    respond_to do |format|
      format.html { flash[:success] = 'Patient was successfully removed.'
                    redirect_to admin_patients_url }
      @current_patients = Patient.all
      ActionCable.server.broadcast 'patients', html: render_to_string('admin/patients/index', layout: false)
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

  def resolve_layout
    case action_name
    when "new", "create", "show" 
      "admin/layouts/application"
    else # index
      "admin/layouts/index_layout"
    end
  end

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
