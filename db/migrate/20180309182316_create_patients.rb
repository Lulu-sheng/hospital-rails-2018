class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.date :admitted_on
      t.string :emergency_contact
      t.string :blood_type
      t.references :doctor, foreign_key: true
      t.references :room, foreign_key: true 

      t.timestamps
    end
  end
end
