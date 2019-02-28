class WagesController < ApplicationController
  layout 'home'
  def index
    @employees = Employee.all
  end

  def show
    @wage = Wage.find(params[:id])
  end

  def import_wage
    if !(params[:year].present? and params[:month].present?)
      flash[:alert] = "请选择年份和月份"
    else
      if !params[:file].present?
        flash[:alert] = "您还没有选择文件哦"
      else
        message = Wage.import_table(params[:file], params[:year], params[:month])
        if message[:employee].present?
          flash[:alert] = "#{message[:employee]}"
        else
          Wage.import_table(params[:file], params[:year], params[:month])
          flash[:notice] = "上传成功"
        end
      end  
    end
    redirect_to wages_path
  end

end
