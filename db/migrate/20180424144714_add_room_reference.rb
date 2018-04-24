class AddRoomReference < ActiveRecord::Migration[5.1]
  def change
    add_reference :patients, :room, foreign_key: true
  end
end
