class CreateDoctors < ActiveRecord::Migration[5.1]
  def change
    create_table :doctors do |t|
        t.string :email
        t.float :salary
        t.string :name
        t.string :specialty
        t.date :received_license
        t.references :mentor, index: true
    end
  end
end
