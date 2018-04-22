require 'test_helper'

class NurseAssignmentTest < ActiveSupport::TestCase
    test "valid nurse and patient association" do
        assert_not nurse_assignments(:one).patient.nil?
        assert_not nurse_assignments(:one).nurse.nil?
    end

    test "valid start date" do
        nurseAssignment = NurseAssignment.new(start_date: '99999999')
        assert nurseAssignment.invalid?
        assert_equal ['must be valid date and must be in the past'], nurseAssignment.errors[:start_date]
        nurseAssignment = NurseAssignment.new(start_date: '20190101')
        assert nurseAssignment.invalid?
        assert_equal ['must be valid date and must be in the past'], nurseAssignment.errors[:start_date]
    end
end
