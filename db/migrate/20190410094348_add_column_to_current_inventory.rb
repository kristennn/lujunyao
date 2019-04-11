class AddColumnToCurrentInventory < ActiveRecord::Migration[5.2]
  def change
    add_column :commodity_current_inventories, :current_inventory, :integer, default: 0
  end
end
