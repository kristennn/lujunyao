class ChangeColumnOfCommodity < ActiveRecord::Migration[5.2]
  def change
    rename_column :commodities, :standart, :standard
  end
end
