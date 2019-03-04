class EmployeesController < ApplicationController
  layout 'home'
  def index
    @employees = Employee.all
  end
 
  def show
    @employee = Employee.find(params[:id])
    @update_events = UpdateEvent.where(table_name: "employees", stuff_id: @employee.id)
  end

  def new 
    @employee = Employee.new
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def create
    employee = Employee.find_by(name: params[:name])
    if employee.present?
      flash[:alert] = "人员的姓名不能重复，您填写的姓名已存在"
    else
      @employee = Employee.new(employee_params)
      @employee.save
      flash[:notice] = "新增成功"
    end
    redirect_to employees_path
  end

  def update
    @employee = Employee.find(params[:id])
    transfer_columns = {
      "name" => "姓名", 
      "sex" => "性别", 
      "job_number" => "工号", 
      "worktype" => "工种", 
      "department" => "部门", 
      "duty" => "职务", 
      "birth_date" => "出生日期", 
      "working_date" => "入职日期"
    }
    transfer_columns.each do |column|
      employee_attributes = @employee.attributes
      if employee_attributes["#{column[0]}"].present?
        if (employee_attributes["#{column[0]}"] != params[:employee][column[0]])
          UpdateEvent.create(stuff_id: @employee.id, table_name: "employees", field_name: "#{column[1]}", field_old_value: "#{employee_attributes[column[0]]}", field_new_value: "#{params[:employee][column[0]]}")
        end
      end
    end
    @employee.update(employee_params)
    flash[:notice] = "修改成功"
    redirect_to employees_path
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.destroy
    flash[:notice] = "已将该人员删除"
    redirect_to employees_path
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

  private

  def employee_params
    params.require(:employee).permit(:name, :sex, :job_number, :worktype, :department, :duty, :birth_date, :working_date)
  end

end
