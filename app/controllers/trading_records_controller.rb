class TradingRecordsController < ApplicationController
  layout 'home'

  def index
    if (params[:year].present?) && (params[:month].present?)
      @year = params[:year]
      @month = params[:month]
      @trading_records = TradingRecord.where(year: @year, month: @month)
    else
      @year = Time.now.year
      @month = Time.now.month
      @trading_records = TradingRecord.all
    end
  end

  def show
    @trading_record = TradingRecord.find(params[:id])
    @update_events = UpdateEvent.where(table_name: "trading_records", stuff_id: @trading_record.id)
  end

  def new
    @commodities = Commodity.where(id: params[:commodity_id])
    @trading_record = TradingRecord.new
    @employees = Employee.all
  end

  def create
    @commodities = Commodity.where(id: params[:trading].keys)
    @employees = Employee.all
    error = {}
    commodity_ids = []
    employee_ids = []
    params[:trading].keys.each do |commodity_id|
      employee_id = params[:trading]["#{commodity_id}"]["employee_id"]
      quantity = params[:trading]["#{commodity_id}"]["quantity"]     
      discount = params[:trading]["#{commodity_id}"]["discount"]
      price = (Commodity.find(commodity_id).selling_price) * discount.to_f
      total_amount = price * quantity.to_i
      com_cur_inven = CommodityCurrentInventory.find_by(commodity_id: commodity_id)
      wage = Wage.where(employee_id: employee_id).last
      if quantity.to_i > com_cur_inven.current_inventory
        commodity_ids << commodity_id
        error[1] = commodity_ids       
      elsif total_amount > wage.accumulative_virtual_money
        employee_ids << employee_id
        error[2] = employee_ids       
      end
    end
    if error.present?
      if error.keys.include?(1)
        commodity_names = Commodity.where(id: error[1]).pluck(:name).uniq.compact
        flash[:alert] = "您添加的#{commodity_names}交易数量超出库存，请检查"
      else 
        employee_names = Employee.where(id: error[2]).pluck(:name).uniq.compact
        flash[:alert] = "本次交易的总金额超出了#{employee_names}的剩余易货币金额，请检查"
      end
      render :new
    else
      params[:trading].keys.each do |commodity_id|
        employee_id = params[:trading]["#{commodity_id}"]["employee_id"]
        quantity = params[:trading]["#{commodity_id}"]["quantity"]
        discount = params[:trading]["#{commodity_id}"]["discount"]
        price = (Commodity.find(commodity_id).selling_price) * discount.to_f
        total_amount = price * quantity.to_i
        com_cur_inven = CommodityCurrentInventory.find_by(commodity_id: commodity_id)
        wage = Wage.where(employee_id: employee_id).last
        #录入交易记录
        TradingRecord.create(commodity_id: commodity_id, employee_id: employee_id, discount_price: price, quantity: quantity, discount: discount, total_amount: total_amount)    
        #减少商品的库存
        current_inventory = com_cur_inven.current_inventory - quantity.to_i
        CommodityInventory.create(commodity_id: commodity_id, trading_id: TradingRecord.last.id, operate_type: "出库", quantity: quantity, operator: current_user.name, year: Time.now.year, month: Time.now.month)
        com_cur_inven.update(current_inventory: current_inventory)
        #减少员工的易货币   
        net_virtual_money = wage.net_virtual_money + total_amount
        remaining_virtual_money = wage.accumulative_virtual_money - total_amount
        wage.update(net_virtual_money: net_virtual_money, accumulative_virtual_money: remaining_virtual_money)             
      end
      flash[:notice] = "录入交易成功" 
      redirect_to trading_records_path
    end          
  end

  def update
    trading_record = TradingRecord.find(params[:trading_record_id])
    employee = Employee.find(params[:employee_id])
    old_inventory = CommodityCurrentInventory.find_by(commodity_id: trading_record.commodity_id).current_inventory
    current_inventory = old_inventory + trading_record.quantity - params[:quantity].to_i
    #添加修改记录
    transfer_columns = {
      "discount" => "折扣", 
      "quantity" => "交易数量", 
      "employee_id" => "员工姓名"
    }
    trading_attributes = trading_record.attributes
    transfer_columns.each do |column|
      if (trading_attributes["#{column[0]}"] != params[column[0]])
        if column[0] == "employee_id"
          UpdateEvent.create(stuff_id: trading_record.id, table_name: "trading_records", field_name: "#{column[1]}", field_old_value: "#{Employee.find(trading_attributes[column[0]]).name}", field_new_value: "#{Employee.find(params[column[0]]).name}")
        else
          UpdateEvent.create(stuff_id: trading_record.id, table_name: "trading_records", field_name: "#{column[1]}", field_old_value: "#{trading_attributes[column[0]]}", field_new_value: "#{params[column[0]]}")
        end     
      end
    end
    #更新交易记录
    total_amount = Commodity.find(trading_record.commodity_id).selling_price * params[:discount].to_f * params[:quantity].to_i
    trading_record.update(employee_id: employee.id, discount: params[:discount], quantity: params[:quantity], total_amount: total_amount)
    #更新出库记录及当前库存
    CommodityInventory.find_by(trading_id: params[:trading_record_id]).update(quantity: params[:quantity])
    CommodityCurrentInventory.find_by(commodity_id: trading_record.commodity_id).update(current_inventory: current_inventory)
    
    flash[:notice] = "修改成功"
    redirect_to trading_records_path
  end
  
 
  

  def show_edit_modal
    @trading_record = TradingRecord.find(params[:trading_record_id])
    respond_to do |format|
      format.js
    end
  end

  def choose_commodity
    @commodity_types = Commodity.pluck(:commodity_type_name).uniq.compact
    @commodity_names = Commodity.pluck(:name).uniq.compact
    if params[:commodity_type].present? && params[:commodity_name].present?
      @type = params[:commodity_type]
      @name = params[:commodity_name]
      @commodities = Commodity.where(commodity_type_name: params[:commodity_type], name: params[:commodity_name]) 
    elsif params[:commodity_type].present?
      @type = params[:commodity_type]
      @commodities = Commodity.where(commodity_type_name: params[:commodity_type]) 
    elsif params[:commodity_name].present?
      @name = params[:commodity_name]
      @commodities = Commodity.where(name: params[:commodity_name]) 
    else
      @commodities = Commodity.all
    end
  end

  private

  def trading_record_params
    params.require(:trading_record).permit(:quantity, :discount, :employee_id, :commodity_id)
  end

end
 