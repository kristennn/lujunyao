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
end
