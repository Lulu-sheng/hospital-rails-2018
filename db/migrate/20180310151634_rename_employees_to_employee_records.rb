class RenameEmployeesToEmployeeRecords < ActiveRecord::Migration[5.1]
    def self.up
        rename_table :employees, :employee_records
    end

    def self.down
        rename_table :employee_records, :employees
    end
end
