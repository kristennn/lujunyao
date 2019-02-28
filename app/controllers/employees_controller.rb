class EmployeesController < ApplicationController
  layout 'home'
  def index
    @employees = Employee.all
  end
 
  def show
    @employee = Employee.find(params[:id])
  end

  def import_employee
    if !params[:file].present?
      flash[:alert] = "您还没有选择文件哦"
    else
      message = Employee.import_table(params[:file])
      if message[:name].present?
        flash[:alert] = "#{message[:name]}"
      else
        Employee.import_table(params[:file])
        flash[:notice] = "上传成功"
      end
    end
    redirect_to employees_path
  end
end
