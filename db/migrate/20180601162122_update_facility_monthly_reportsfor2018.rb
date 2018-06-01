class UpdateFacilityMonthlyReportsfor2018 < ActiveRecord::Migration
  def up
    execute %(
      
      DROP VIEW facility_monthly_reports;

      CREATE VIEW facility_monthly_reports AS SELECT wfmr.*  
        FROM workbook_facility_monthly_reports wfmr
        JOIN workbook_files wf ON wf.id = wfmr.workbook_file_id
        WHERE wf.status = 'active'
      ;
    )
  end
  def down
    execute "DROP VIEW facility_monthly_reports;"
  end
end