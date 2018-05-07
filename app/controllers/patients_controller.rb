class PatientsController < ApplicationController
  layout :resolve_layout
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_patient
=begin
        # all doctors before queries (seeded)
        @patients = Patient.all

        # first query: the number of patients per floor
        @patientPerFloorHash =Patient.joins(:room).group(:floor).count(:id)
=end

  def change_ownership
    # second query: change all of the patients that are under Justin to be under Emily
    @Emily = Doctor.joins(:employee_record).where('employee_records.name': 'Emily Smith').first
    @Justin = Doctor.joins(:employee_record).where('employee_records.name': 'Justin Wong')
    @JustinPatients = Patient.where(doctor_id: @Justin).update_all(doctor_id: @Emily.id) #.update(doctor_id: @Emily)

    @patientsAfterSwap = Patient.all
  end

  def add_patient
    # third query: create a new patient and assign to room 217 and Justin
    @Justin = Doctor.joins(:employee_record).where('employee_records.name': 'Justin Wong').first
    @room = Room.where(number:217).first
    newPatient = @Justin.patients.build(name: 'Bob McNugget', admitted_on:'20180330', emergency_contact:'Tim McNugget', blood_type:'O', room_id: @room.id)
    newPatient.save
    @patientsAfterAdd = Patient.all
  end

  def remove_patient
    # fourth query: destroy patient
    @patientToDestroy = Patient.where(name:'Mark Matthews').first
    if @patientToDestroy != nil
      @patientToDestroy.destroy
    end
    @patientsAfterDestroy = Patient.all
  end

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
    if (params[:nurse_id])
      @assignments = NurseAssignment.joins(:patient).where(nurse_id: params[:nurse_id])
      @assignments = @assignments.partition { |assignment| assignment.end_date.nil? }
      p @assignments

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

      #@assignments = NurseAssignment.where(nurse_id: params[:nurse_id]).select(:patient_id)
      #@patients = Patient.where(id: @assignments)
    else
      # all doctors before queries (seeded)
      @current_patients = Patient.all
    end
  end

  # GET /line_items/new
  def new
    @patient = Patient.new

    @doctor_array =
      Doctor.all.to_a.map do |doctor|
        { name: doctor.employee_record.name,
          value: doctor.id,
          is_student: !doctor.mentor_id.nil?
          #email: EmployeeRecord.where(employee_id: doctor.mentor_id).first.email
        }
      end

    @url =
      if params[:nurse_id].to_i == @user_nurse.id
        nurse_patients_path
      elsif params[:nurse_id]
        respond_to do |format|
          format.html { flash[:warning] = 'You can\'t assign patients to other nurses other than yourself'
                        redirect_back fallback_location: patients_path}
        end
      else
        patients_path
      end
  end

  def create
    @patient = Patient.new(patient_params)

    unless params[:email_check].nil?
      @doctor_assigned = Doctor.find(params[:patient][:doctor_id])
    end
    #unless @doctor_assigned.mentor_id.nil? 
    #@email = EmployeeRecord.where(employee_id: @doctor_assigned).first.email

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
                    redirect_to patients_path }
      @current_patients = Patient.all
      ActionCable.server.broadcast 'patients', html: render_to_string('patients/index', layout: false)
    else
      logger.error "Invalid parameters for a patient record"
      # I MUST PASS IN THE VARIABLE BUT ALSO ONLY RENDER SO THIS RATCHET NESS!
      format.html { @doctor_array =
                    Doctor.all.to_a.map do |doctor|
                      { name: doctor.employee_record.name,
                        value: doctor.id,
                        is_student: !doctor.mentor_id.nil?
                      }
                    end
                    render :new }
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
    #render json: {status: 'SUCCESS', message: 'Loaded patient information', data: patient}, status: :ok
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

=begin
        @JustinPatients.each do |patient|
            patient.update(doctor_id: @Emily)
        end

        # first query
        @luluDoctor = Doctor.joins(:employee_record).where('employee_records.name':'Lulu Sheng')
        @patientsUnderLulu = Patient.where(doctor_id:@luluDoctor)

        @result = []
        @patientsUnderLulu.each do |patient|
            @result << Nurse.joins(:employee_record).where(id: patient.nurses)
        end

        # second query: the name of the nurse who works the least amount of hours per week
        @leastHours = Nurse.minimum(:hours_per_week)
        @minHours = Nurse.where(hours_per_week:@leastHours).first

        # third query: total number of night-shift nurses
        @numOfNightShift = Nurse.where(night_shift:true).count(:id)
=end
end

