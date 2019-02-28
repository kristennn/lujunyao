class Employee < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.import_table(file)
    head_transfer = {
      "工号" => "job_number",
      "姓名" => "name",
      "性别" => "sex",
      "出生日期" => "birth_date",
      "上班时间" => "working_date",
      "工种" => "worktype",
      "部门" => "department",
      "职务" => "duty"
    }
    spreadsheet = Roo::Spreadsheet.open(file.path)
    message = Hash.new
    header = spreadsheet.row(1).map{ |i| head_transfer[i]}
    (2..spreadsheet.last_row).each do |j|
      row = Hash[[header, spreadsheet.row(j)].transpose]
      employee = find_by(name: row["name"]) || new
      employee.attributes = row
      if employee.name.present?
        employee.save!
      else
        message[:name] = "姓名不得为空，请检查后再上传"
      end
    end
    return message
  end

end
