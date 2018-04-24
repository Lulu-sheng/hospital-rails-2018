class ChangeRoomWingColumn < ActiveRecord::Migration[5.1]
=begin
  def up
      change_column :rooms, :wing, :string
  end

  def down
      Raise ActiveRecord::IrreversibleMigration
  end
=end
end
