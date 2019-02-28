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

end
