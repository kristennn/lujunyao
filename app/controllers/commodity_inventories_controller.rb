class CommodityInventoriesController < ApplicationController
  layout 'home'
  def index
    @commodities = Commodity.all
  end

  def show
    @commodity = Commodity.find(params[:id])
  end
end
