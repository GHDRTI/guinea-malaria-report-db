class CreateWorkbookFacilityMonthlyReports < ActiveRecord::Migration
  def change
    create_table :workbook_facility_monthly_reports do |t|
      t.references :workbook_file, index: true, foreign_key: true, 
        index: {name: 'index_wfmr_on_workbook_file_id'}
      t.references :health_facility, index: true, foreign_key: true,
        index: {name: 'index_wfmr_on_health_facility_id'}
        
      t.integer :population_total
      t.integer :population_covered
      t.integer :num_services
      t.integer :num_reports_compiled
      t.integer :num_pregnant_anc_tested
      t.integer :num_pregnant_first_dose_sp
      t.integer :num_pregnant_three_doses_sp
      t.integer :num_structures
      t.integer :num_agents
      t.integer :num_local_ngos_cbos
      t.string :compiled_by_name
      t.string :compiled_by_org
      t.string :compiled_by_phone
      t.date :compiled_by_date
      t.string :approved_by_name
      t.string :approved_by_org
      t.string :approved_by_phone
      t.date :approved_by_date

      t.timestamps null: false
    end
  end
end
