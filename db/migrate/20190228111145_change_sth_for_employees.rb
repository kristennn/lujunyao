class ChangeSthForEmployees < ActiveRecord::Migration[5.2]
  def change
    change_column :employees, :sex, :string
  end
end
