class CreateWorkbookFacilityInventoryReports < ActiveRecord::Migration
  def change
    create_table :workbook_facility_inventory_reports do |t|
      t.references :workbook_facility_monthly_report, index: true, foreign_key: true, 
        index: {name: 'index_wfir_on_wfmr_id'}
      t.string :product
      t.integer :stock_month_start
      t.integer :stock_month_received
      t.integer :num_delivered_to_ac
      t.integer :num_delivered_to_ps
      t.integer :num_used
      t.integer :num_lost
      t.integer :num_close_to_expire
      t.integer :num_days_out_of_stock

      t.timestamps null: false
    end
  end
end
