class EmployeeRecord < ApplicationRecord

    belongs_to :employee, polymorphic: true
    validates :name, presence: true, length: { minimum: 2}
    validates :salary, numericality: { greater_than: 0, message: "invalid negative salary amount", allow_nil: true} # allow the validation to be skipped when the value is nil
    validates :email, presence: true, uniqueness: true
end
