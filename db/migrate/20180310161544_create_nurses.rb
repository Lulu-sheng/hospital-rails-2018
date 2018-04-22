class CreateNurses < ActiveRecord::Migration[5.1]
  def change
    create_table :nurses do |t|
      t.boolean :night_shift
      t.integer :hours_per_week
      t.date :date_of_certification

      t.timestamps
    end
  end
end
