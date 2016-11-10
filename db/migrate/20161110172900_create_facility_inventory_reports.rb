class CreateFacilityInventoryReports < ActiveRecord::Migration
  def up
    execute %(
      CREATE VIEW facility_inventory_reports AS SELECT wfir.* 
        FROM workbook_facility_inventory_reports wfir
        JOIN workbook_facility_monthly_reports wfmr on wfmr.id = wfir.workbook_facility_monthly_report_id
        JOIN workbook_files wf ON wf.id = wfmr.workbook_file_id
        WHERE wf.status = 'active'
      ;
    )
  end
  def down
    execute "DROP VIEW facility_inventory_reports;"
  end
end