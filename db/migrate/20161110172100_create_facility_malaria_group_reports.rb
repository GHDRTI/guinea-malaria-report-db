class CreateFacilityMalariaGroupReports < ActiveRecord::Migration
  def up
    execute %(
      CREATE VIEW facility_malaria_group_reports AS SELECT wfmgr.* 
        FROM workbook_facility_malaria_group_reports wfmgr
        JOIN workbook_facility_monthly_reports wfmr on wfmr.id = wfmgr.workbook_facility_monthly_report_id
        JOIN workbook_files wf ON wf.id = wfmr.workbook_file_id
        WHERE wf.status = 'active'
      ;
    )
  end
  def down
    execute "DROP VIEW facility_malaria_group_reports;"
  end
end