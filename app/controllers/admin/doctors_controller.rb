class Admin::DoctorsController < ApplicationController
  layout :resolve_layout
  def index
    # all doctors before queries (seeded)
    @doctors = Doctor.all

    # first query: the average salary of student doctors
    @studentAvgSal = Doctor.where.not(mentor_id: nil).joins(:employee_record).average(:salary)
  end

  def update_mentor_salary
    # second query: update all of the mentor doctor salaries by 10$
    @mentors = Doctor.select(:mentor_id).where.not(mentor_id: nil)

    @arrayOfMentorRecords = EmployeeRecord.where(employee_id:@mentors).to_a
    @arrayOfMentorRecords.each do |record|
      record.increment!(:salary, 10)
    end
    @doctorsAfterSalaryUpdate = Doctor.all
  end

  def sort_doctors
    @doctors = Doctor.all.order(received_license: :asc)
    @studentAvgSal = Doctor.where.not(mentor_id: nil).joins(:employee_record).average(:salary)
    render "index"
  end

  def create
    @doctor = Doctor.new(doctor_params)
    @employee = @doctor.build_employee_record(employee_params)

    respond_to do |format|
      if [@doctor.save, @employee.save].all?
        #NewAccountMailer.notice_new_account(@nurse).deliver_later
        format.html { flash[:success] = 'Doctor was successfully created'
                      redirect_to admin_doctors_path }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    doctor = Doctor.find(params[:id])

    doctor.destroy
    respond_to do |format|
      # this is so that if you delete yourself, you are logged out
      format.html { flash[:success] = 'Doctor was successfully removed from the system'
                    redirect_to admin_doctors_url }
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    @employee = @doctor.employee_record
  end

  def update
    @doctor = Doctor.find(params[:id])
    @employee = @doctor.employee_record
    @previous_email = @employee.gravatar

    respond_to do |format|
      if [@doctor.update(doctor_params), @employee.update(employee_params)].all?
        format.html { flash[:success] = 'Doctor was successfully updated'
                      redirect_to admin_doctors_path }
        unless @previous_email.eql?(@doctor.employee_record.email)
          GenerateHashJob.perform_later(@doctor)
        end
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

  def resolve_layout
    case action_name
    when "new", "create", "edit", "update"
      "admin/layouts/application"
    else # index
      "admin/layouts/index_layout"
    end
  end
end

