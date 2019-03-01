class ChangeColumnOfCommodityInventory < ActiveRecord::Migration[5.2]
  def change
    change_column :commodity_inventories, :operate_type, :string
  end
end
