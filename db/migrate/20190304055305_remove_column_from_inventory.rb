class RemoveColumnFromInventory < ActiveRecord::Migration[5.2]
  def change
    remove_column :commodity_inventories, :current_inventory, :integer
    add_column :commodity_inventories, :trading_id, :integer
  end
end
