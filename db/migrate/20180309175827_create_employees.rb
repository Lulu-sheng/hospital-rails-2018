class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :email
      t.float :salary
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
