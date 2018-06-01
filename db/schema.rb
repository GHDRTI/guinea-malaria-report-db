# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20180601162122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "districts", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "alternative_names", default: [],              array: true
  end

  create_table "health_facilities", force: :cascade do |t|
    t.text     "name"
    t.text     "alternative_names", default: [],              array: true
    t.integer  "district_id"
    t.text     "location"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "health_facilities", ["district_id"], name: "index_health_facilities_on_district_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "name"
    t.text     "email"
    t.string   "login_key"
    t.datetime "login_key_expires"
    t.datetime "last_login_time"
    t.string   "last_login_ip"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "workbook_facility_inventory_reports", force: :cascade do |t|
    t.integer  "workbook_facility_monthly_report_id"
    t.string   "product"
    t.integer  "stock_month_start"
    t.integer  "stock_month_received"
    t.integer  "num_delivered_to_ac"
    t.integer  "num_delivered_to_ps"
    t.integer  "num_used"
    t.integer  "num_lost"
    t.integer  "num_close_to_expire"
    t.integer  "num_days_out_of_stock"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "workbook_facility_inventory_reports", ["workbook_facility_monthly_report_id"], name: "index_wfir_on_wfmr_id", using: :btree

  create_table "workbook_facility_malaria_group_reports", force: :cascade do |t|
    t.integer  "workbook_facility_monthly_report_id"
    t.string   "group"
    t.string   "registration_method"
    t.integer  "total_patients_all_causes"
    t.integer  "total_deaths"
    t.integer  "suspect_severe_deaths_male"
    t.integer  "suspect_severe_deaths_female"
    t.integer  "suspect_simple_male"
    t.integer  "suspect_simple_female"
    t.integer  "suspect_severe_male"
    t.integer  "suspect_severe_female"
    t.integer  "tested_microscope"
    t.integer  "tested_rdt"
    t.integer  "confirmed_microscope"
    t.integer  "confirmed_rdt"
    t.integer  "treated_act_male"
    t.integer  "treated_act_female"
    t.integer  "treated_severe_male"
    t.integer  "treated_severe_female"
    t.integer  "total_referrals"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "workbook_facility_malaria_group_reports", ["workbook_facility_monthly_report_id"], name: "index_wfmgr_on_wfmr_id", using: :btree

  create_table "workbook_facility_monthly_reports", force: :cascade do |t|
    t.integer  "workbook_file_id"
    t.integer  "health_facility_id"
    t.integer  "population_total"
    t.integer  "population_covered"
    t.integer  "num_services"
    t.integer  "num_reports_compiled"
    t.integer  "num_pregnant_anc_tested"
    t.integer  "num_pregnant_first_dose_sp"
    t.integer  "num_pregnant_three_doses_sp"
    t.integer  "num_structures"
    t.integer  "num_agents"
    t.integer  "num_local_ngos_cbos"
    t.string   "compiled_by_name"
    t.string   "compiled_by_org"
    t.string   "compiled_by_phone"
    t.date     "compiled_by_date"
    t.string   "approved_by_name"
    t.string   "approved_by_org"
    t.string   "approved_by_phone"
    t.date     "approved_by_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "num_pregnant_second_dose_sp"
    t.integer  "num_pregnant_fourth_dose_sp"
    t.integer  "num_awareness_session"
    t.integer  "llin_dist_cpn"
    t.integer  "llin_dist_pev"
  end

  add_index "workbook_facility_monthly_reports", ["health_facility_id"], name: "index_wfmr_on_health_facility_id", using: :btree
  add_index "workbook_facility_monthly_reports", ["workbook_file_id"], name: "index_wfmr_on_workbook_file_id", using: :btree

  create_table "workbook_files", force: :cascade do |t|
    t.integer  "workbook_id"
    t.integer  "user_id"
    t.text     "filename"
    t.text     "storage_url"
    t.string   "status"
    t.datetime "uploaded_at"
    t.json     "validation_errors"
    t.json     "import_errors"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.json     "import_overrides"
  end

  add_index "workbook_files", ["user_id"], name: "index_workbook_files_on_user_id", using: :btree
  add_index "workbook_files", ["workbook_id"], name: "index_workbook_files_on_workbook_id", using: :btree
  add_index "workbook_files", ["workbook_id"], name: "index_workbook_files_unique_active", unique: true, where: "((status)::text = 'active'::text)", using: :btree

  create_table "workbooks", force: :cascade do |t|
    t.integer  "reporting_month"
    t.integer  "reporting_year"
    t.integer  "district_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "end_date"
  end

  add_index "workbooks", ["district_id", "reporting_year", "reporting_month"], name: "index_workbook_on_district_year_month", unique: true, using: :btree
  add_index "workbooks", ["district_id"], name: "index_workbooks_on_district_id", using: :btree

  add_foreign_key "health_facilities", "districts"
  add_foreign_key "workbook_facility_inventory_reports", "workbook_facility_monthly_reports"
  add_foreign_key "workbook_facility_malaria_group_reports", "workbook_facility_monthly_reports"
  add_foreign_key "workbook_facility_monthly_reports", "health_facilities"
  add_foreign_key "workbook_facility_monthly_reports", "workbook_files"
  add_foreign_key "workbook_files", "users"
  add_foreign_key "workbook_files", "workbooks"
  add_foreign_key "workbooks", "districts"
end
