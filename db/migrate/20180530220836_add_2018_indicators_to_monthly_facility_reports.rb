class Add2018IndicatorsToMonthlyFacilityReports < ActiveRecord::Migration
  def change
  	add_column :workbook_facility_monthly_reports, :num_pregnant_second_dose_sp, :integer
  	add_column :workbook_facility_monthly_reports, :num_pregnant_fourth_dose_sp, :integer
  	add_column :workbook_facility_monthly_reports, :num_awareness_session, :integer
  	add_column :workbook_facility_monthly_reports, :llin_dist_cpn, :integer
  	add_column :workbook_facility_monthly_reports, :llin_dist_pev, :integer
  end
end
