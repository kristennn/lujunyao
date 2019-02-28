class Commodity < ApplicationRecord

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :unit, presence: true
  validates :standart, presence: true
  validates :purchase_price, presence: true
  validates :selling_price, presence: true


  def self.import_table(file)
    head_transfer = {
      "商品名称" => "name",
      "商品编码" => "commodity_code",
      "商品种类编码" => "commodity_type_code",
      "商品种类名称" => "commodity_type_name",
      "计量单位" => "unit",
      "规格型号" => "standart",
      "进货价" => "purchase_price",
      "销售价" => "selling_price"
    }
    spreadsheet = Roo::Spreadsheet.open(file.path)
    message = Hash.new
    header = spreadsheet.row(1).map{ |i| head_transfer[i]}
    (2..spreadsheet.last_row).each do |j|
      row = Hash[[header, spreadsheet.row(j)].transpose]
      commodity = find_by(name: row["name"]) || new
      commodity.attributes = row
      if commodity.name.present? and commodity.unit.present? and commodity.standart.present? and commodity.purchase_price.present? and commodity.selling_price.present?
        commodity.save!
      else
        message[:name] = "商品名称、计量单位、规格型号、进货价与销售价不得为空，请检查后再上传"
      end
    end
    return message
  end

end
 