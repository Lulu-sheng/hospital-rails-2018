class Admin::NursesController < Admin::BaseController
  layout :resolve_layout

  # this is before the transaction is actually committed
  def index
    @nurses = Nurse.all
  end

  def create
    @nurse = Nurse.new(nurse_params)
    @employee = @nurse.build_employee_record(employee_params)

    respond_to do |format|
      if [@nurse.save, @employee.save].all?
        format.html { flash[:success] = 'Nurse was successfully created'
                      redirect_to nurses_path }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    nurse = Nurse.find(params[:id])

    nurse.destroy
    respond_to do |format|
      # this is so that if you delete yourself, you are logged out
      if params[:id] == session[:nurse_id].to_s
        session[:nurse_id] = nil
        format.html { flash[:warning] = 'Please log in'
                      redirect_to login_url }
      else
        format.html { flash[:success] = 'Nurse was successfully removed from the system'
                      redirect_to nurses_url }
      end
    end
  end

  # this is bubbled up from the transaction failure
  rescue_from 'Nurse::Error' do |exception|
    flash[:warning] = exception.message
    redirect_to nurses_url
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
        format.html { flash[:success] = 'Nurse was successfully updated'
                      redirect_to nurses_path }
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
                                  :'date_of_certification(3i)', :night_shift, :hours_per_week,
                                  :username, :password, :password_confirmation)
  end

  def employee_params
    params.require(:employee_record).permit(:name, :email, :salary)
  end

  def invalid_nurse
    logger.error "Attempt to access invalid nurse #{params[:id]}"
    flash[:warning] = 'Invalid nurse'
    redirect_to nurses_url
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
