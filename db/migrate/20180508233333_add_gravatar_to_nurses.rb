class AddGravatarToNurses < ActiveRecord::Migration[5.1]
  def change
    add_column :employee_records, :gravatar, :string
    change_column_default :employee_records, :gravatar, from: nil, to: 'https://www.gravatar.com/avatar/d69ab4fb9bb28c0527e972273614f585'
  end
end
