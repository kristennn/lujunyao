class CommodityInventoriesController < ApplicationController
  layout 'home'
  def index
    @commodities = Commodity.all
  end

  def show
    @commodity = Commodity.find(params[:id])
  end

  def show_modal
    @commodity = Commodity.find(params[:commodity_id])
    respond_to do |format|
      format.js
    end
  end

  def create
    if CommodityInventory.where(commodity_id: params[:commodity_id]).present?
      old_inventory = CommodityInventory.where(commodity_id: params[:commodity_id]).last.current_inventory
    else
      old_inventory = 0
    end
    current_inventory = old_inventory + params[:quantity].to_i
    commodity_inventory = CommodityInventory.new(commodity_id: params[:commodity_id], quantity: params[:quantity],current_inventory: current_inventory , operate_type: "入库", year: Time.now.year, month: Time.now.month, operator: current_user.name)
    commodity_inventory.save!
    flash[:notice] = "入库操作成功"
    redirect_to commodity_inventories_path
  end

end
