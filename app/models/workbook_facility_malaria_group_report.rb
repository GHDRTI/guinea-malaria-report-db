class WorkbookFacilityMalariaGroupReport < ActiveRecord::Base
  belongs_to :workbook_facility_monthly_report

  GROUPS = [
    :below_five,
    :five_and_above,
    :pregnant
  ]

  REGISTRATIONS = [
    :structure,
    :agent,
    :death
  ]

  ROW_MAPPING = {
    below_five: {
      structure: 11,
      agent: 12,
      death: 14
    },
    five_and_above: {
      structure: 16,
      agent: 17,
      death: 19
    },
    pregnant: {
      structure: 21,
      agent: 22,
      death: 24
    }
  }

  def self.report_for report, group, reg
    props = {
      workbook_facility_monthly_report: report, 
      group: group, 
      registration_method: reg
    }
    where(props).first || WorkbookFacilityMalariaGroupReport.new(props)
  end


  def apply_sheet! sheet
    row = ROW_MAPPING[group.to_sym][registration_method.to_sym]

    self.total_patients_all_causes    = sheet.cell('D', row)
    self.suspect_simple_male          = sheet.cell('E', row)
    self.suspect_simple_female        = sheet.cell('F', row)
    self.suspect_severe_male          = sheet.cell('G', row)
    self.suspect_severe_female        = sheet.cell('F', row)
    self.tested_microscope            = sheet.cell('J', row)
    self.tested_rdt                   = sheet.cell('K', row)
    self.confirmed_microscope         = sheet.cell('M', row)
    self.confirmed_rdt                = sheet.cell('N', row)
    self.treated_act_male             = sheet.cell('P', row)
    self.treated_act_female           = sheet.cell('Q', row)
    self.treated_severe_male          = sheet.cell('R', row)
    self.treated_severe_female        = sheet.cell('S', row)
    self.total_referrals              = sheet.cell('U', row)

    self.save!
  end

end
