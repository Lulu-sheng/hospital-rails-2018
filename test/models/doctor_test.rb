require 'test_helper'

class DoctorTest < ActiveSupport::TestCase
    # doctors only have validations on their specialty attribute

    test "valid has_one association" do
        assert_not doctors(:jendoctor).employee_record.nil?
    end

    test "empty specialty test" do
        doctor = Doctor.new
        assert doctor.invalid?
        assert doctor.errors[:specialty].any?
    end

    test "invalid specialty test" do
        doctor = Doctor.new(specialty: 'food')
        assert doctor.invalid?
        assert doctor.errors[:specialty].any?
    end

    test "invalid received_license (pastness)" do
        doctor = Doctor.new(specialty: 'food', received_license: '20190101')
        assert doctor.invalid?
        assert_equal ["must be valid date and must be in the past"], doctor.errors[:received_license]
    end

    test "invalid received_license" do
        doctor = Doctor.new(specialty: 'food', received_license: '20174444')
        assert doctor.invalid?
        assert_equal ["must be valid date and must be in the past"], doctor.errors[:received_license]
    end

    test "mentorship association" do
        assert_not doctors(:bob).mentor.nil?
        assert_equal 1, doctors(:jendoctor).student_doctors.size

        # mentor association is optional
        assert_not doctors(:jendoctor).errors[:mentor].any?
    end

    test "patients association" do
        assert_equal 2, doctors(:jendoctor).patients.size
        assert_not doctors(:jendoctor).patients.first.nil?
    end

end
