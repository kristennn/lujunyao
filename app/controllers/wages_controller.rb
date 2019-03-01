class WagesController < ApplicationController
  layout 'home'
  def index
    @employees = Employee.all
    @wage = Wage.new
  end

  def show
    @wage = Wage.find(params[:id])
  end

  def create
    employee_id = Employee.find_by(name: params[:wage]["employee_id"]).id
    wage = Wage.find_by(employee_id: employee_id, year: params[:year], month: params[:month])
    if wage.present?
      flash[:warning] = "#{params[:wage]["employee_id"]}在#{params[:year]}年#{params[:month]}月的应发工资已录入，如需修改请使用修改功能"
    else
      Wage.create(employee_id: employee_id, year: params[:year], month: params[:month], gross_cash: params[:wage]["gross_cash"], gross_virtual_money: params[:wage]["gross_virtual_money"])
      flash[:notice] = "录入工资成功"
    end 
    redirect_to wages_path
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
