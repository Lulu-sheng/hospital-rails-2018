require 'test_helper'

class EmployeeRecordTest < ActiveSupport::TestCase
    #validates :name, presence: true, length: { minimum: 2}
    #validates :salary, numericality: { greater_than: 0, message: "invalid negative salary amount", allow_nil: true} # allow the validation to be skipped when the value is nil
    #validates :email, presence: true, uniqueness: true

    test "valid belongs_to employee" do
        assert_not employee_records(:jennifer).employee.nil?
        assert_not employee_records(:helen).employee.nil?
    end

    test "test empty employee record" do
        record = EmployeeRecord.new
        assert record.invalid?
        assert_equal ["can't be blank", "is too short (minimum is 2 characters)"], record.errors[:name]
        assert_equal [], record.errors[:salary]
        assert_equal ["can't be blank"], record.errors[:email]
        # must belong to an employee
        assert_equal ["must exist"], record.errors[:employee]
    end

    test "email uniqueness test" do
        # this uses the fixture 'one'
        record = EmployeeRecord.new(email: employee_records(:jennifer).email)
        #record = EmployeeRecord.new(name: 'Jennifer', salary: 1000000, email: 'gmail.com')
        assert record.invalid?
        assert record.errors[:email].any?
    end

    test "negative salary test" do
        record = EmployeeRecord.create(name: 'Jennifer', salary: -1000000, email: 'gmail.com')
        assert record.invalid?
        assert record.errors[:salary].any?
    end

=begin
    test "valid belongs_to association" do
        assert_not employee_records(:jennifer).employee.nil?
    end
=end
end
