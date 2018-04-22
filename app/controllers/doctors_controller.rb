class DoctorsController < ApplicationController
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

=begin
        @mentors = Doctor.select(:mentor_id).where.not(mentor_id: nil).to_a

        # this actually returns the employee records of the student doctors (which is a bit counter intuitive...)
        EmployeeRecord.joins("INNER JOIN doctors ON doctors.id = employee_id AND employee_type = 'doctor'").where.not('doctors.mentor_id': @mentors)
        EmployeeRecord.joins(:employee).where(employee_type:'doctor')
            .where.not(Doctor_id: @mentors).update(salary: EmployeeRecord.salary + 10)
=end

        # s = EmployeeRecord.joins("INNER JOIN doctors ON doctors.id = employee_id AND employee_type = 'doctor'")

        
=begin
        Doctor.where.not(id: @mentors).each do |doctor|
            doctor.increment!(:salary, 10)
        end
=end

end

