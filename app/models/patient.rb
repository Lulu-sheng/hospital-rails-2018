class Patient < ApplicationRecord
    has_many :nurse_assignments, dependent: :destroy
    has_many :nurses, through: :nurse_assignments
    belongs_to :doctor
    belongs_to :room

    validates :name, presence: true, length: { minimum: 2}
    validates :admitted_on, presence: true
    validates :emergency_contact, presence: { message: "patient must specify the name of their emergency contact" } 
    validates :blood_type, inclusion: { in: %w(O B AB)}
end
