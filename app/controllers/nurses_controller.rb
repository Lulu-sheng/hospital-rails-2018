require 'date'
class NursesController < ApplicationController
  layout :resolve_layout
  def index
    # all doctors before queries (seeded)
    @nurses = Nurse.all

    # first query: get the name of the nurses that take care of employees that are
    # under the care of doctor Lulu Sheng
    @luluDoctor = Doctor.joins(:employee_record).where('employee_records.name':'Lulu Sheng')
    @patientsUnderLulu = Patient.where(doctor_id:@luluDoctor)

    @luluNurses = []
    @patientsUnderLulu.each do |patient|
      @luluNurses << Nurse.joins(:employee_record).where(id: patient.nurses).select('employee_records.name')
    end

    # second query: the name of the nurse who works the least amount of hours per week
    @leastHours = Nurse.minimum(:hours_per_week)
    #@nurseWithLeastHrs = Nurse.where(hours_per_week:@leastHours).first
    @nurseWithLeastHrs = Nurse.joins(:employee_record).where(hours_per_week:@leastHours).select('employee_records.name').first

    # third query: total number of night-shift nurses
    @numOfNightShift = Nurse.where(night_shift:true).count(:id)
  end

  def create
    @nurse = Nurse.new(nurse_params)
    @employee = @nurse.build_employee_record(employee_params)

    respond_to do |format|
      if [@nurse.save, @employee.save].all?
        format.html { redirect_to nurses_path, notice: 'Nurse was successfully created'}
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @nurse = Nurse.find(params[:id])
    @employee = @nurse.employee_record
  end

  def update
    @nurse = Nurse.find(params[:id])
    @employee = @nurse.employee_record

    respond_to do |format|
      if [@nurse.update(nurse_params), @employee.update(employee_params)].all?
        format.html { redirect_to nurses_path, notice: 'Nurse was successfully updated'}
      else
        format.html { render :edit }
      end
    end
  end

  def sort
    @nurses = Nurse.all.order(date_of_certification: :asc)
    render 'index'
  end

  def new
    @nurse = Nurse.new
    @employee = EmployeeRecord.new
  end

  private
  def nurse_params
    params.require(:nurse).permit(:'date_of_certification(1i)', :'date_of_certification(2i)', 
                                  :'date_of_certification(3i)', :night_shift, :hours_per_week)
  end

  def employee_params
    params.require(:employee_record).permit(:name, :email, :salary)
  end

  def invalid_nurse
    logger.error "Attempt to access invalid nurse #{params[:id]}"
    redirect_to nurses_url, notice: 'Invalid nurse'
  end

  def resolve_layout
    case action_name
    when "new", "create", "edit", "update"
      "application"
    else # index
      "index_layout"
    end
  end

end

