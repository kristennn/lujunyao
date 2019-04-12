class CommoditiesController < ApplicationController
  layout 'home'

  def index
    @commodities = Commodity.all
  end

  def new
    @commodity = Commodity.new
  end

  def show
    @commodity = Commodity.find(params[:id])
    @update_events = UpdateEvent.where(table_name: "commodities", stuff_id: @commodity.id)
  end

  def edit
    @commodity = Commodity.find(params[:id])
  end

  def create
    commodity = Commodity.find_by(name: params[:name])
    if commodity.present?
      flash[:alert] = "商品名称不能重复，您填写的名称已存在"
    else
      @commodity = Commodity.new(commodity_params)
      @commodity.save!
      CommodityCurrentInventory.create(commodity_id: @commodity.id, current_inventory: 0)
      flash[:notice] = "新增成功"
    end
    redirect_to commodities_path
  end

  def update
    @commodity = Commodity.find(params[:id])
    transfer_columns = {
      "name" => "商品名称", 
      "commodity_code" => "商品编码", 
      "commodity_type_name" => "商品种类名称", 
      "commodity_type_code" => "商品种类编码", 
      "unit" => "计量单位", 
      "standard" => "规格型号", 
      "purchase_price" => "进货价", 
      "selling_price" => "销售价"
    }
    transfer_columns.each do |column|
      commodity_attributes = @commodity.attributes
      if params[:commodity][column[0]].present?
        if (commodity_attributes["#{column[0]}"] != params[:commodity][column[0]])
          UpdateEvent.create(stuff_id: @commodity.id, table_name: "commodities", field_name: "#{column[1]}", field_old_value: "#{commodity_attributes[column[0]]}", field_new_value: "#{params[:commodity][column[0]]}")
        end
      end
    end
    @commodity.update(commodity_params)
    flash[:notice] = "修改成功"
    redirect_to commodities_path
  end

  def destroy
    commodity = Commodity.find(params[:id])
    commodity.destroy
    CommodityCurrentInventory.find_by(commodity_id: params[:id]).delete
    flash[:notice] = "已将该商品删除"
    redirect_to commodities_path
  end

  def import_commodity
    if !params[:file].present?
      flash[:alert] = "您还没有选择文件哦"
    else
      message = Commodity.import_table(params[:file])
      if message[:name].present?
        flash[:alert] = "#{message[:name]}"
      else
        flash[:notice] = "上传成功"
      end
    end
    
    redirect_to commodity_inventories_path
  end

  private

  def commodity_params
    params.require(:commodity).permit(:name, :commodity_code, :commodity_type_name, :commodity_type_code, :unit, :standard, :purchase_price, :selling_price)
  end

end
