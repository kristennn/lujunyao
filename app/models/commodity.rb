class Commodity < ApplicationRecord

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :unit, presence: true
  validates :standard, presence: true
  validates :commodity_type_name, presence: true
  #多图上传
  has_many :photos
  accepts_nested_attributes_for :photos

  def self.import_table(file)
    
    head_transfer = {
      "商品名称" => "name",
      "商品编码" => "commodity_code",
      "商品种类编码" => "commodity_type_code",
      "商品类别" => "commodity_type_name",
      "计量单位" => "unit",
      "规格型号" => "standard",
      "入库数量" => "quantity",
      "经办人" => "operator", 
      "生产日期" => "produce_date",
      "保质期" => "warranty_period",
      # "进货价" => "purchase_price",
      "销售价" => "selling_price"
    }

    spreadsheet = Roo::Spreadsheet.open(file.path)
    message = Hash.new
    header = spreadsheet.row(1).map{ |i| head_transfer[i]}
    inventory_headers = ["quantity", "operator", "produce_date", "warranty_period"]
    inventory_datas = []
    inventory_datas = {
      "operate_type" => "入库",
      "year" => Time.now.year,
      "month" => Time.now.month 
    }.to_a
    (2..spreadsheet.last_row).each do |j|     
      row = Hash[[header, spreadsheet.row(j)].transpose]
      commodity = find_by(name: row["name"]) || new
      commodity_inventory = CommodityInventory.new
      row.each do |m|
        if inventory_headers.include?(m[0])
          inventory_datas << m
          row.delete(m[0])
        end 
      end
      commodity.attributes = row
      if inventory_datas.to_h["produce_date"] == nil
        if inventory_datas.to_h["warranty_period"] == nil
          inventory_datas << ["produce_date", "30000101"]
          inventory_datas << ["warranty_period", 0]
        end
        inventory_datas << ["warranty_period", 0]
      end
      
      commodity_inventory.attributes = inventory_datas.to_h
      
      if commodity.name.present? and commodity.unit.present? and commodity.standard.present? and commodity.commodity_type_name.present? and commodity.selling_price.present? and commodity_inventory.quantity.present?
        commodity.save!
        commodity_inventory.commodity_id = commodity.id
        commodity_inventory.save!
        com_cur_inven = CommodityCurrentInventory.find_by(commodity_id: commodity_inventory.commodity_id, produce_date: commodity_inventory.produce_date) || CommodityCurrentInventory.new
        current_inventory = com_cur_inven.current_inventory + commodity_inventory.quantity
        com_cur_inven.update(commodity_id: commodity_inventory.commodity_id, produce_date: commodity_inventory.produce_date, current_inventory: current_inventory)
      else
        message[:name] = "商品名称、计量单位、规格型号、商品类别和入库数量不得为空，请检查后再上传"
      end
    end
    return message
  end

end
 