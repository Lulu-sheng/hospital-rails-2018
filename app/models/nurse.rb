class Nurse < ApplicationRecord
  after_destroy :ensure_a_nurse_remains
  has_many :nurse_assignments
  has_many :patients, through: :nurse_assignments
  has_one :employee_record, as: :employee, dependent: :destroy

  # this is precense validation for booleans
  validates :night_shift, inclusion: {in: [false, true] }
  validates :hours_per_week, presence: true
  validate :date_of_certification_valid?
  validates :username, presence: true, uniqueness: true
  has_secure_password

  def date_of_certification_valid?
    if !date_of_certification.is_a?(Date) || date_of_certification > Time.now
      errors.add(:date_of_certification, 'must be valid date and must be in the past')
    end
  end

  class Error < StandardError
  end

  private

  def ensure_a_nurse_remains
    if Nurse.count.zero?
      raise Error.new "Can't delete last nurse"
    end 
  end
end
