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

  def update
    @wage = Wage.find(params[:id])
    transfer_columns = {
      "gross_cash" => "应发现金", 
      "gross_virtual_money" => "应发易货币", 
      "net_cash" => "实发现金"
    }
    wage_attributes = @wage.attributes
    transfer_columns.each do |column|
      binding.pry
      if (wage_attributes["#{column[0]}"] != params[:wage][column[0]])
        UpdateEvent.create(stuff_id: @wage.id, table_name: "wages", field_name: "#{column[1]}", field_old_value: "#{wage_attributes[column[0]]}", field_new_value: "#{params[:wage][column[0]]}")
      end
    end
    @wage.update(gross_cash: params[:wage]["gross_cash"], gross_virtual_money: params[:wage]["gross_virtual_money"], net_cash: params[:wage]["net_cash"])
    flash[:notice] = "修改成功"
    redirect_to wages_path
  end

  def show_edit_modal
    @wage = Wage.find_by(employee_id: params[:employee_id], year: params[:year], month: params[:month])
    respond_to do |format|
      format.js
    end
  end

  def show_pay_modal
    @wage = Wage.find_by(employee_id: params[:employee_id], year: params[:year], month: params[:month])
    respond_to do |format|
      format.js
    end
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
