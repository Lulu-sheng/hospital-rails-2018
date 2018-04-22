class CreateNurseAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :nurse_assignments do |t|
      t.belongs_to :patient, index: true
      t.belongs_to :nurse, index: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
