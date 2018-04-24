class PatientsController < ApplicationController
  layout :resolve_layout
    def index
        # all doctors before queries (seeded)
        @patients = Patient.all

        # first query: the number of patients per floor
        @patientPerFloorHash =Patient.joins(:room).group(:floor).count(:id)
    end

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
      @patients = Patient.all.order(name: :desc)
      render 'index'
    end

    def subset_under_nurse
      @assignments = NurseAssignment.where(nurse_id: params[:nurse_id]).select(:patient_id)
      @patients = Patient.where(id: @assignments)
      render 'index'
    end

    private

    def resolve_layout
      case action_name
      when "new", "create" 
        "application"
      else # index
        "index_layout"
      end
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

