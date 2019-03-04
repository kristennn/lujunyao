class ChangeSthToWage < ActiveRecord::Migration[5.2]
  def change
    remove_column :wages, :gross_salary
    change_column :wages, :gross_cash, :integer, default: 0
    change_column :wages, :gross_virtual_money, :integer, default: 0
    change_column :wages, :net_cash, :integer, default: 0
    change_column :wages, :net_virtual_money, :integer, default: 0
    change_column :wages, :accumulative_cash, :integer, default: 0
    change_column :wages, :accumulative_virtual_money, :integer, default: 0
  end
end
