require 'test_helper'

class NurseTest < ActiveSupport::TestCase

  test "username uniqueness test" do
    nurse = Nurse.new(username: nurses(:one).username)
    assert nurse.invalid?
    assert_equal ["has already been taken"], nurse.errors[:username]
  end

  test "username presence test" do
    nurse = Nurse.new()
    assert nurse.invalid?
    assert_equal ["can't be blank"], nurse.errors[:username]
  end

  test "password presence and length test" do
    nurse = Nurse.new()
    assert nurse.invalid?
    assert_equal ["can't be blank", "is too short (minimum is 5 characters)"], nurse.errors[:password]
  end

  test "valid has_one association" do
    assert_not nurses(:one).employee_record.nil?
  end

  test "date of certification test" do
    nurse = Nurse.new(date_of_certification: '20190101')
    assert nurse.invalid?
    assert_equal ["must be valid date and must be in the past"], nurse.errors[:date_of_certification]
    nurse2 = Nurse.new(date_of_certification: '20174444')
    assert nurse2.invalid?
    assert_equal ["must be valid date and must be in the past"], nurse.errors[:date_of_certification]
  end

  test "valid night shift" do
    nurse = Nurse.new
    assert nurse.invalid?
    assert nurse.errors[:night_shift].any?
  end

  test "hours per week test" do
    nurse = Nurse.new
    assert nurse.invalid?
    assert nurse.errors[:hours_per_week].any?
    #assert nurse.errors[:night_shift].any? so inclusion exludes nulls too
  end

  test "patients association" do
    assert_equal 3, nurses(:one).patients.size
  end

=begin
    validates :night_shift, inclusion: {in: [false, true] }
    validates :hours_per_week, presence: true
    validate :date_of_certification_valid?
=end
end
