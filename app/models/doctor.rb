class Doctor < ApplicationRecord
    has_many :student_doctors, class_name: "Doctor", foreign_key: "mentor_id"

    # a doctor does not have to belong to a mentor
    belongs_to :mentor, class_name: "Doctor", optional: true
    has_many :patients
    has_one :employee_record, as: :employee

    validates :specialty, presence: true, inclusion: { in: %w(family neurology pediatrics orthopedic plastic emergency cardiology) }
    validate :received_license_is_valid?

    def received_license_is_valid?
        if !received_license.is_a?(Date) || received_license > Time.now
            errors.add(:received_license, 'must be valid date and must be in the past')
        end
    end
end
