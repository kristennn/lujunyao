class AddColumnToInventory < ActiveRecord::Migration[5.2]
  def change
    add_column :commodity_inventories, :produce_date, :string, comment: '生产日期', default: '2100101'
    add_column :commodity_inventories, :warranty_period, :integer, comment: '保质期', default: 0
  end
end
