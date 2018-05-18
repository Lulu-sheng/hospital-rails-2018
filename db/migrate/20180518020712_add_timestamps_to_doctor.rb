class AddTimestampsToDoctor < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:doctors)
  end
end
