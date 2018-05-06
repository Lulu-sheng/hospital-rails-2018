class MentorConfirmationMailer < ApplicationMailer
  default from: 'Lulu Sheng lulu.sheng1418@gmail.com'

  # make it so that we are able to pass in a user
  def assigned(student_doctor, message)
    @mentor_employee_record = EmployeeRecord.where(employee_id: student_doctor.mentor_id).first
    @student_doctor_name = EmployeeRecord.where(employee_id: student_doctor).first.name
    @message = message

    mail to: @mentor_employee_record.email, subject: "Your Student, #{@student_doctor_name}, Has Been Assigned To A Patient"
  end
end
