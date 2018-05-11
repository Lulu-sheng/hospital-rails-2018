require 'test_helper'

class PatientTest < ActiveSupport::TestCase
    test "belongs_to room doctor association" do
        assert_not patients(:one).doctor.nil?
        assert_not patients(:one).room.nil?
    end

    test "has_many nurses association" do
        assert_equal 1, patients(:one).nurses.size
    end

    test "empty patient validation" do
        patient = Patient.new
        assert patient.invalid?
        assert_equal ["can't be blank", "is too short (minimum is 2 characters)"], patient.errors[:name]
        assert patient.errors[:admitted_on].any?
        assert_equal ["can't be blank"], patient.errors[:emergency_contact]
    end

    test "valid blood_type" do
        patient = Patient.new(blood_type: 'P')
        assert patient.invalid?
        assert patient.errors[:blood_type].any?
    end


=begin
 validates :name, presence: true, length: { minimum: 2}
    validates :admitted_on, presence: true
    validates :emergency_contact, presence: { message: "patient must specify the name of their emergency contact" } 
    validates :blood_type, inclusion: { in: %w(O B AB)}
=end
    
end
