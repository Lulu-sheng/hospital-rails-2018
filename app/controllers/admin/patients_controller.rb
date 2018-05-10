class Admin::PatientsController < Admin::BaseController
  layout :resolve_layout
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_patient

  def sort
    @current_patients = 
      if params[:nurse_id]
        Nurse.find(params[:nurse_id]).patients.order(name: :asc)
      else
        Patient.all.order(name: :asc)
      end
    #render 'patients/index'
    render :index
  end

  def index
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

    else
      # all doctors before queries (seeded)
      @current_patients = Patient.all
    end
    #render 'patients/index'
  end

  # GET /patients/new
  def new
    @patient = Patient.new

    @doctor_array = get_doctors

    @url =
      if params[:nurse_id].to_i == @user_nurse.id
        nurse_patients_path
      elsif params[:nurse_id]
        respond_to do |format|
          format.html { flash[:warning] = 'You can\'t assign patients to other nurses other than yourself'
                        redirect_back fallback_location: admin_patients_path}
        end
      else
        patients_path
      end
    #render 'patients/new'
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
          #OrderMailer.assigned(@user_nurse, @doctor_assigned, params[:email_text]).deliver_later
        end

        format.html { flash[:success] = 'Patient record was successfully created.'
                      redirect_to 'hospital-management.myshopify.io/admin/patients' }
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
    #render 'patients/show'
  end

  def destroy
    @patient = Patient.find(params[:id])
    if @patient.nurses.to_a.include? @user_nurse
      @patient.destroy
      respond_to do |format|
        format.html { flash[:success] = 'Patient was successfully removed.'
                      redirect_to admin_patients_url }
        @current_patients = Patient.all
        ActionCable.server.broadcast 'patients', html: render_to_string('patients/index', layout: false)
      end
    else
      respond_to do |format|
        format.html { flash[:warning] = 'You cannot remove a patient that is not under your care' 
                      redirect_to admin_patients_url }
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

  def resolve_layout
    case action_name
    when "new", "create", "show" 
      "application"
    else # index
      "index_layout"
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