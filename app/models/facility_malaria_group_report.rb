class FacilityMalariaGroupReport < ActiveRecord::Base

  self.primary_key = 'id'
  
  belongs_to :facility_monthly_report, 
    foreign_key: 'workbook_facility_monthly_report_id', 
    class_name: 'FacilityMonthlyReport'

  ELEMENT_DHIS2_MAPPING = {
    patients_consulted: 'FmShhQ6Z8GR',
    suspected_cases: 'yKwOfmrjzZn',
    tested_cases: 'ike0ycQxIym',
    confirmed_cases: 'aDCSfIzPYRb',
    cases_treated_act: 'bjYtgZobniH',
    severe_cases_treated: 'waEPPJt6i2w',
    total_malaria_deaths: 'xQO8Ih3iypf',
    cases_referred: 'xA3a48dewoN',
    total_deaths: 'qTUlwvb6MSK'
  }

  DHIS2_DISAGGREGATIONS = {
    male: {
      below_five: {
        value: 'Ko736JDuMpS',
        structure: {
          value: 'WDat8LGPNQS',
          mild: 'J6qg36Eu1nV',
          severe: 'zF6vshnGUzS'
        },
        agent: {
          value: 'pqaubN9JI1p',
          mild: 'Yc3rNNTfNpx',
          severe: 'XtybUBClBZ7'
        }
      },
      five_and_above: {
        value: 'vy4Dft3Ve0F',
        structure: {
          value: 'CLBnWnadQ9E',
          mild: 'WHoGFquOKhq',
          severe: 'BeGPctkVt03'
        },
        agent: {
          value: 'x2ngRqtVRad',
          mild: 'Yi0tSxTT2x6',
          severe: 'tretksnl5dC'
        }
      },
      pregnant: {
        value: 'mwWVhp05Wik',
        structure: {
          value: 'nfmG13f7IBD',
          mild: 'b5rQjBJviNA',
          severe: 'WLQT4xcsBGi'
        },
        agent: {
          value: 'iHYLvyq03qN',
          mild: 'gBcVBh6DCmA',
          severe: 'ZPKjd3N1Hkp'
        }
      }
    },
    female: {
      below_five: {
        value: 'H45kYod8uU3',
        structure: {
          value: 'DuTndxFrb2I',
          mild: 'ta2YZa73xVT',
          severe: 'U1LK0zGEZ34'
        },
        agent: {
          value: 'FRFr0GItaK7',
          mild: 'ELdrd653D8d',
          severe: 'TzqpO6WWvhV'
        }
      },
      five_and_above: {
        value: 'IIOvZ8QAOe7',
        structure: {
          value: 'GTc6GzQn9vJ',
          mild: 'q7AOvcPROE9',
          severe: 'PfadgWAn53n'
        },
        agent: {
          value: 'NLZ1qYf2emi',
          mild: 'WiWmRyQdSRw',
          severe: 'ppnUrlU5ftK'
        }
      },
      pregnant: {
        value: 'uVoAqEeSGCQ',
        structure: {
          value: 'mPRYxJ7B3sp',
          mild: 'z79NVF2tE3A',
          severe: 'K03piv0D058'
        },
        agent: {
          value: 'CkgaOEbsEO1',
          mild: 'L2nm4fP049b',
          severe: 'zk8rY8m42p4'
        }
      }
    },
    below_five: {
      value: 'B5E0y3ds8Lw',
      structure: {
        value: 'Pyyy4k05NMD',
        by_microscope: 'SIuZ3OPsuzn',
        by_rdt: 'G4YHG5Yl8e1'
      },
      agent: {
        value: 'AgCYNOA6VIN',
        by_microscope: 'GLSs3Cx0E0I',
        by_rdt: 'OmtqmwJ7txz'
      }
    },
    five_and_above: {
      value: 'AWOdwyIPq97',
      structure: {
        value: 'hTTSJHNRJrD',
        by_microscope: 'iSKqqDcVR9t',
        by_rdt: 'nXWAJzXBQWJ'
      },
      agent: {
        value: 'a2L8HdWI8eN',
        by_microscope: 'COMuMVRloyt',
        by_rdt: 'hfokSylMOVP'
      }
    },
    pregnant: {
      value: 'el8gaWXsBfr',
      structure: {
        value: 'py1lfmaC6uz',
        by_microscope: 'WAgcbKnQIyT',
        by_rdt: 'ksI9EPccMjd'
      },
      agent: {
        value: 'mdIr1MXnmEE',
        by_microscope: 'iSaSrdaCH48',
        by_rdt: 'DY0Rxya1nBJ'
      }
    }
  }  

  def field_to_attr_dissag field
    g = group.to_sym
    r = registration_method.to_sym
    if field == :total_patients_all_causes && !total_patients_all_causes.nil?
      if r == :death
        return {
          element: ELEMENT_DHIS2_MAPPING[:total_deaths],
          category: DHIS2_DISAGGREGATIONS[g][:value],
          value: total_patients_all_causes
        }
      else
        return {
          element: ELEMENT_DHIS2_MAPPING[:patients_consulted],
          category: DHIS2_DISAGGREGATIONS[g][r][:value],
          value: total_patients_all_causes
        }
      end
    elsif field == :suspect_simple_male && !suspect_simple_male.nil? && r != :death
      return {
        element: ELEMENT_DHIS2_MAPPING[:suspected_cases],
        category: DHIS2_DISAGGREGATIONS[:male][g][r][:mild],
        value: suspect_simple_male
      }
    elsif field == :suspect_simple_female && !suspect_simple_female.nil? && r != :death
      return {
        element: ELEMENT_DHIS2_MAPPING[:suspected_cases],
        category: DHIS2_DISAGGREGATIONS[:female][g][r][:mild],
        value: suspect_simple_female
      }
    elsif field == :suspect_severe_male && !suspect_severe_male.nil?
      if r == :death
        return {
          element: ELEMENT_DHIS2_MAPPING[:total_malaria_deaths], 
          category: DHIS2_DISAGGREGATIONS[:male][g][:value],
          value: suspect_severe_male
        }
      else
        return {
          element: ELEMENT_DHIS2_MAPPING[:suspected_cases],
          category: DHIS2_DISAGGREGATIONS[:male][g][r][:severe],
          value: suspect_severe_male
        }
      end
    elsif field == :suspect_severe_female && !suspect_severe_female.nil?
      if r == :death
        return {
          element: ELEMENT_DHIS2_MAPPING[:total_malaria_deaths],
          category: DHIS2_DISAGGREGATIONS[:female][g][:value],
          value: suspect_severe_female
        }
      else
        return {
          element: ELEMENT_DHIS2_MAPPING[:suspected_cases],
          category: DHIS2_DISAGGREGATIONS[:female][g][r][:severe],
          value: suspect_severe_female
        }
      end
    elsif field == :suspect_severe_female && suspect_severe_female.nil? && r != :death
      return {
          element: ELEMENT_DHIS2_MAPPING[:suspected_cases],
          category: DHIS2_DISAGGREGATIONS[:female][g][r][:severe],
          value: 0
        }
    elsif field == :tested_microscope && !tested_microscope.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:tested_cases],
        category: DHIS2_DISAGGREGATIONS[g][r][:by_microscope],
        value: tested_microscope
      }
    elsif field == :tested_rdt && !tested_rdt.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:tested_cases],
        category: DHIS2_DISAGGREGATIONS[g][r][:by_rdt],
        value: tested_rdt
      }
    elsif field == :confirmed_microscope && !confirmed_microscope.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:confirmed_cases],
        category: DHIS2_DISAGGREGATIONS[g][r][:by_microscope],
        value: confirmed_microscope
      }
    elsif field == :confirmed_rdt && !confirmed_rdt.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:confirmed_cases],
        category: DHIS2_DISAGGREGATIONS[g][r][:by_rdt],
        value: confirmed_rdt
      }
    elsif field == :treated_act_male && !treated_act_male.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:cases_treated_act],
        category: DHIS2_DISAGGREGATIONS[:male][g][r][:value],
        value: treated_act_male
      }
    elsif field == :treated_act_female && !treated_act_female.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:cases_treated_act],
        category: DHIS2_DISAGGREGATIONS[:female][g][r][:value],
        value: treated_act_female
      }
    elsif field == :treated_severe_male && !treated_severe_male.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:severe_cases_treated],
        category: DHIS2_DISAGGREGATIONS[:male][g][r][:value],
        value: treated_severe_male
      }
    elsif field == :treated_severe_female && !treated_severe_female.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:severe_cases_treated],
        category: DHIS2_DISAGGREGATIONS[:female][g][r][:value],
        value: treated_severe_female
      }
    elsif field == :total_referrals && !total_referrals.nil?
      return {
        element: ELEMENT_DHIS2_MAPPING[:cases_referred],
        category: DHIS2_DISAGGREGATIONS[g][r][:value],
        value: total_referrals
      }
    end
  end

  def suspect_severe_female_elements
    ([
      to_dhis2_element(field_to_attr_dissag(:suspect_severe_female))
    ]).compact
  end

  def dhis2_elements
    ([
      to_dhis2_element(field_to_attr_dissag(:total_patients_all_causes)),
      to_dhis2_element(field_to_attr_dissag(:suspect_simple_male)),
      to_dhis2_element(field_to_attr_dissag(:suspect_simple_female)),
      to_dhis2_element(field_to_attr_dissag(:suspect_severe_male)),
      to_dhis2_element(field_to_attr_dissag(:suspect_severe_female)),
      to_dhis2_element(field_to_attr_dissag(:tested_microscope)),
      to_dhis2_element(field_to_attr_dissag(:tested_rdt)),
      to_dhis2_element(field_to_attr_dissag(:confirmed_microscope)),
      to_dhis2_element(field_to_attr_dissag(:confirmed_rdt)),
      to_dhis2_element(field_to_attr_dissag(:treated_act_male)),
      to_dhis2_element(field_to_attr_dissag(:treated_act_female)),
      to_dhis2_element(field_to_attr_dissag(:treated_severe_male)),
      to_dhis2_element(field_to_attr_dissag(:treated_severe_female)),
      to_dhis2_element(field_to_attr_dissag(:total_referrals)),
    ]).compact
  end

  def to_dhis2_element attrs
    return nil unless attrs
    {
      dataElement: attrs[:element],
      period: facility_monthly_report.workbook_file.workbook.dhis2_period,
      orgUnit: facility_monthly_report.health_facility.dhis2_id,
      categoryOptionCombo: attrs[:category],
      attributeOptionCombo: "HllvX50cXC0",
      value: attrs[:value],
      followUp: false
    }
  end

end
