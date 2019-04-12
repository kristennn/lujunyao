class CommodityInventoriesController < ApplicationController
  layout 'home'
  def index
    if params[:commodity_type].present? and params[:commodity_name].present?
      @type = params[:commodity_type]
      @name = params[:commodity_name]
      @commodities = Commodity.where(commodity_type_name: params[:commodity_type], name: params[:commodity_name]) 
    else
      if params[:commodity_type].present?
        @type = params[:commodity_type]
        @commodities = Commodity.where(commodity_type_name: params[:commodity_type])
      elsif params[:commodity_name].present?
        @name = params[:commodity_name]
        @commodities = Commodity.where(name: params[:commodity_name])
      else     
        @commodities = Commodity.where(commodity_type_name: (Commodity.pluck(:commodity_type_name).uniq.first))
      end
    end  
    @commodity_types = Commodity.pluck(:commodity_type_name).uniq.compact
    @commodity_names = Commodity.pluck(:name).uniq.compact

    @export_commodities = Commodity.where(id: params[:commodity_ids])
    respond_to do |format|
      format.html
      format.csv { send_data [@export_commodities, @type].to_csv }
      format.xls { headers["Content-Disposition"] = 'attachment; filename="商品库存表.xls"'}
    end
  end

  def show
    @commodity = Commodity.find(params[:id])
    if params[:type].present?
      @type = params[:type]
      @commodity_inventories = CommodityInventory.where(commodity_id: @commodity.id, operate_type: @type)
    else
      @commodity_inventories = CommodityInventory.where(commodity_id: @commodity.id)
    end
  end

  def show_modal
    @commodity = Commodity.find(params[:commodity_id])
    respond_to do |format|
      format.js
    end
  end

  def edit_modal
    @commodity_inventory = CommodityInventory.find(params[:commodity_inventory_id])
    respond_to do |format|
      format.js
    end
  end

  def create
    com_cur_inven = CommodityCurrentInventory.find_by(commodity_id: params[:commodity_id])
    if com_cur_inven.present?
      old_inventory = com_cur_inven.current_inventory
    else
      old_inventory = 0
    end
    current_inventory = old_inventory + params[:quantity].to_i
    CommodityInventory.create(commodity_id: params[:commodity_id], quantity: params[:quantity], freight: params[:freight], operate_type: "入库", year: Time.now.year, month: Time.now.month, operator: current_user.name)
    com_cur_inven.update(current_inventory: current_inventory)
    flash[:notice] = "入库操作成功"
    redirect_to commodity_inventories_path
  end

  def update
    commodity_inventory = CommodityInventory.find(params[:commodity_inventory_id])
    com_cur_inven = CommodityCurrentInventory.find_by(commodity_id: commodity_inventory.commodity_id)
    transfer_columns = {
      "quantity" => "入库数量", 
      "freight" => "运费"
    }
    transfer_columns.each do |column|
      inventory_attributes = commodity_inventory.attributes
      if (inventory_attributes["#{column[0]}"] != params[column[0]])
        UpdateEvent.create(stuff_id: commodity_inventory.id, table_name: "commodity_inventories", field_name: "#{column[1]}", field_old_value: "#{inventory_attributes[column[0]]}", field_new_value: "#{params[column[0]]}")
      end
    end  
    old_inventory = com_cur_inven.current_inventory - commodity_inventory.quantity
    current_inventory = old_inventory + params[:quantity].to_i
    commodity_inventory.update(quantity: params[:quantity], freight: params[:freight])
    com_cur_inven.update(current_inventory: current_inventory)
    flash[:notice] = "修改成功"
    redirect_to commodity_inventory_path(commodity_inventory.commodity_id)
  end

  def update_event
    @commodity_inventory = CommodityInventory.find(params[:id])
    @update_events = UpdateEvent.where(table_name: "commodity_inventories", stuff_id: params[:id])
  end

  def download_template
    @export_commodities = Commodity.where(id: params[:commodity_ids])
    respond_to do |format|
      format.html
      format.csv { send_data [@export_commodities, @type].to_csv }
      format.xls { headers["Content-Disposition"] = 'attachment; filename="商品上传模板.xls"'}
    end
  end

end
