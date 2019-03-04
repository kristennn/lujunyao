class CreateCommodityCurrentInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :commodity_current_inventories do |t|
      t.integer :commodity_id
      t.integer :current_inventory
      t.timestamps
    end
  end
end
