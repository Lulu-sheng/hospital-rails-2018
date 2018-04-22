class NurseAssignment < ApplicationRecord
  belongs_to :patient
  belongs_to :nurse
  validate :start_date_valid?

  def start_date_valid?
        if !start_date.is_a?(Date) || start_date > Time.now
            errors.add(:start_date, 'must be valid date and must be in the past')
        end
    end
end
