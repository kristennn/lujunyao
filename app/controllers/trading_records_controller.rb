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

  def new
    @commodities = Commodity.where(id: params[:commodity_id])
    @trading_record = TradingRecord.new
    @employees = Employee.all
  end

  def update

    flash[:notice] = "修改成功"
    redirect_to trading_records_path
  end
  #1. 更新交易记录
  #2. 更新出库记录
  #3. 添加修改记录

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
      @commodities = Commodity.where(commodity_type_name: params[:commodity_type], name: params[:commodity_name]) 
    elsif params[:commodity_type].present?
      @commodities = Commodity.where(commodity_type_name: params[:commodity_type]) 
    elsif params[:commodity_name].present?
      @commodities = Commodity.where(name: params[:commodity_name]) 
    else
      @commodities = Commodity.all
    end
  end

end
 