class CreateWorkbookFacilityMalariaGroupReports < ActiveRecord::Migration
  def change
    create_table :workbook_facility_malaria_group_reports do |t|
      t.references :workbook_facility_monthly_report, index: true, foreign_key: true, 
        index: {name: 'index_wfmgr_on_wfmr_id'}
      t.string :group
      t.string :registration_method
      t.integer :total_patients_all_causes
      t.integer :total_deaths
      t.integer :suspect_severe_deaths_male
      t.integer :suspect_severe_deaths_female
      t.integer :suspect_simple_male
      t.integer :suspect_simple_female
      t.integer :suspect_severe_male
      t.integer :suspect_severe_female
      t.integer :tested_microscope
      t.integer :tested_rdt
      t.integer :confirmed_microscope
      t.integer :confirmed_rdt
      t.integer :treated_act_male
      t.integer :treated_act_female
      t.integer :treated_severe_male
      t.integer :treated_severe_female
      t.integer :total_referrals

      t.timestamps null: false
    end
  end
end
