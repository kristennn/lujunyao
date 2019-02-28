# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_28_111145) do

  create_table "commodities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "commodity_code", comment: "商品编码"
    t.string "commodity_type_name", comment: "商品种类名称"
    t.integer "commodity_type_code", comment: "商品种类编码"
    t.string "name", comment: "商品名称"
    t.string "unit", comment: "计量单位"
    t.string "standart", comment: "规格型号"
    t.float "purchase_price", comment: "进货价格"
    t.float "selling_price", comment: "销售价格"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commodity_inventories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "commodity_id"
    t.boolean "operate_type", comment: "出入库类型"
    t.integer "quantity", comment: "数量"
    t.integer "current_inventory", comment: "当前库存"
    t.float "freight", comment: "运费"
    t.string "operator", comment: "经办人"
    t.integer "year"
    t.integer "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "job_number", comment: "工号"
    t.string "name", comment: "姓名"
    t.string "sex", comment: "性别"
    t.string "birth_date", comment: "出生日期"
    t.integer "age", comment: "年龄"
    t.string "working_date", comment: "工作日期"
    t.integer "working_years", comment: "工龄"
    t.json "worktype", comment: "工种"
    t.json "duty", comment: "职务"
    t.json "department", comment: "部门"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "trading_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "commodity_id"
    t.integer "employee_id"
    t.integer "quantity", comment: "数量"
    t.float "discount", comment: "折扣"
    t.float "discount_price", comment: "折扣后价格"
    t.float "total_amount", comment: "总金额"
    t.string "operator", comment: "经办人"
    t.integer "year"
    t.integer "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "update_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "stuff_id"
    t.string "table_name", comment: "表格名称"
    t.string "field_name", comment: "字段名称"
    t.string "field_old_value", comment: "字段旧值"
    t.string "field_new_value", comment: "字段新值"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", default: "1", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role_id"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "wages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "employee_id"
    t.float "gross_salary", comment: "应发工资"
    t.float "gross_cash", comment: "应发现金"
    t.float "gross_virtual_money", comment: "应发易货币"
    t.float "net_cash", comment: "实发现金"
    t.float "net_virtual_money", comment: "实发易货币"
    t.float "accumulative_cash", comment: "累计应发现金"
    t.float "accumulative_virtual_money", comment: "累计应发易货币"
    t.integer "year"
    t.integer "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
