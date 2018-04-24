class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :wing
      t.integer :floor
      t.integer :number
      t.boolean :vip

      t.timestamps
    end
  end
end
