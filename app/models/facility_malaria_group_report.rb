class FacilityMalariaGroupReport < ActiveRecord::Base

  belongs_to :facility_monthly_report, foreign_key: 'workbook_facility_monthly_report'

end
