class RemoveInheritedColumnsDoctor < ActiveRecord::Migration[5.1]
  def change
      remove_column :doctors, :email, :string
      remove_column :doctors, :salary, :float
      remove_column :doctors, :name, :string
      remove_column :employee_records, :type, :string
  end
end
