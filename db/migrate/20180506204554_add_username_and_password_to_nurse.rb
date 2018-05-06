class AddUsernameAndPasswordToNurse < ActiveRecord::Migration[5.1]
  def change
    change_table :nurses do |t|
      t.string :username
      t.string :password_digest
    end
  end
end
