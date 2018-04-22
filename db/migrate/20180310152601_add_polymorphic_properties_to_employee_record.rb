class AddPolymorphicPropertiesToEmployeeRecord < ActiveRecord::Migration[5.1]
  def change
      add_reference :employee_records, :employee, polymorphic: true, index: true
      # add_column :employee_records, :employee_id, :string
      # add_column :employee_records, :employee_type, :string
  end
end
