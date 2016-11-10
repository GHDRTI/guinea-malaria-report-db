class AddWorkbookConstraint < ActiveRecord::Migration
  def change
    add_index :workbooks, [:district_id, :reporting_year, :reporting_month], 
      unique: true, name: "index_workbook_on_district_year_month"
  end
end