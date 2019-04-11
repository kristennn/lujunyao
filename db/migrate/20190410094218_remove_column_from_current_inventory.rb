class RemoveColumnFromCurrentInventory < ActiveRecord::Migration[5.2]
  def change
    remove_column :commodity_current_inventories, :current_inventory, :integer
  end
end
