class NewAccountMailer < ApplicationMailer
  default from: 'Lulu Sheng lulu.sheng1418@gmail.com'

  def notice_new_account(new_nurse, password)
    @password = password
    @new_nurse = new_nurse
    @new_employee_record = new_nurse.employee_record
    mail to: @new_employee_record.email, subject: "Welcome To The Hospital, #{@new_employee_record.name}"
  end
end
