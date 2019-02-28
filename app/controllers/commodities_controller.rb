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
      flash[:notice] = "新增成功"
    end
    redirect_to commodities_path
  end

  def update
    @commodity = Commodity.find(params[:id])
    @commodity.update(commodity_params)
    flash[:notice] = "修改成功"
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
        Commodity.import_table(params[:file])
        flash[:notice] = "上传成功"
      end
    end
    redirect_to commodities_path
  end

  private

  def commodity_params
    params.require(:commodity).permit(:name, :commodity_code, :commodity_type_name, :commodity_type_code, :unit, :standart, :purchase_price, :selling_price)
  end

end
