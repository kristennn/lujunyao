class AddDateToCurrentInventory < ActiveRecord::Migration[5.2]
  def change
    add_column :commodity_current_inventories, :produce_date, :string, comment: '生产日期', default: '30000101'
  end
end
