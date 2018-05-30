class Admin::DoctorsController < Admin::BaseController
  layout 'admin/layouts/index_layout', only: [:index, :sort]
  def index
    @doctors = Doctor.includes(:employee_record).references(:employee_record).all
  end

  def sort_doctors
    @doctors = Doctor.all.order(received_license: :asc)
    @studentAvgSal = Doctor.where.not(mentor_id: nil).joins(:employee_record).average(:salary)
    render "index"
  end

=begin
  def swap
  end

  def swap_perform
    doctor_from = Doctor.joins(:employee_record).where('employee_records.name': 'Emily Smith').first
    @Justin = Doctor.joins(:employee_record).where('employee_records.name': 'Justin Wong')
    @JustinPatients = Patient.where(doctor_id: @Justin).update_all(doctor_id: @Emily.id)
    redirect_to admin_doctors_url
  end
=end

  def create
    @doctor = Doctor.new(doctor_params)
    @employee = @doctor.build_employee_record(employee_params)

    respond_to do |format|
      if [@doctor.save, @employee.save].all?
        NewAccountMailer.notice_new_account(@nurse).deliver_later
        format.html { flash[:success] = 'Doctor was successfully created'
                      redirect_to admin_doctors_path }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    doctor = Doctor.find(params[:id])
    dependent = false
    Patient.all.each do |patient|
      if patient.doctor_id.to_s.eql?(params[:id])
        dependent = true
      end
    end

    respond_to do |format|
      unless dependent
        doctor.destroy
        format.html { flash[:success] = 'Doctor was successfully removed from the system'
                      redirect_to admin_doctors_url }
      else
        format.html {flash[:warning] = 'This doctor is still assigned to existing patients'
                     redirect_to admin_doctors_url }
      end
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    @employee = @doctor.employee_record
  end

  def update
    @doctor = Doctor.find(params[:id])
    @employee = @doctor.employee_record

    respond_to do |format|
      if [@doctor.update(doctor_params), @employee.update(employee_params)].all?
        format.html { flash[:success] = 'Doctor was successfully updated'
                      redirect_to admin_doctors_path }
      else
        format.html { render :edit }
      end
    end
  end

  def sort
    @doctors = Doctor.all.order(received_license: :asc)
    render 'index'
  end

  def new
    @doctor = Doctor.new
    @employee = EmployeeRecord.new
  end

  def show
    @doctor = Doctor.find(params[:id])
    @patients_under_doctor = @doctor.patients

    @doctor_nurses = []
    @patients_under_doctor.each do |patient|
      nurses_for_patient = Nurse.where(id: patient.nurses)
      unless nurses_for_patient.empty?
        nurses_for_patient.each do |nurse|
          @doctor_nurses << nurse
        end
      end
    end
    @doctor_nurses = @doctor_nurses.uniq
  end

  private
  def doctor_params
    params.require(:doctor).permit(:'received_license(1i)', :'received_license(2i)', 
                                   :'received_license(3i)', :specialty, :mentor_id)
  end

  def employee_params
    params.require(:employee_record).permit(:name, :email, :salary)
  end

  def invalid_doctor
    logger.error "Attempt to access invalid doctor #{params[:id]}"
    flash[:warning] = 'Invalid doctor'
    redirect_to admin_doctors_url
  end
end

