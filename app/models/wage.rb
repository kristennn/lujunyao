class Wage < ApplicationRecord

  validates :employee_id, presence: true
  validates :employee_id, uniqueness: true

  def self.import_table(file, year, month)
    head_transfer = {
      "姓名" => "employee_id",
      "本月应发现金" => "gross_cash",
      "本月应发易货币" => "gross_virtual_money"
    }
    spreadsheet = Roo::Spreadsheet.open(file.path)
    message = Hash.new
    header = spreadsheet.row(1).map{ |i| head_transfer[i]}
    (2..spreadsheet.last_row).each do |j|
      row = Hash[[header, spreadsheet.row(j)].transpose]

      if Employee.find_by(name: row["employee_id"]).present?
        employee_id = Employee.find_by(name: row["employee_id"]).id
        wage = find_by(employee_id: employee_id, year: year, month: month) || new

        wage.employee_id = employee_id
        wage.gross_cash = row["gross_cash"]
        wage.gross_virtual_money = row["gross_virtual_money"]
        wage.year = year
        wage.month = month
        wage.save!
      else
        message[:employee] = "姓名不得为空，请检查后再上传"
      end
    end
    return message
  end

end
