class FacilityMonthlyReport < ActiveRecord::Base

  has_many :facility_inventory_reports, 
    foreign_key: 'workbook_facility_monthly_report_id', 
    class_name: 'FacilityInventoryReport'
  has_many :facility_malaria_group_reports, 
    foreign_key: 'workbook_facility_monthly_report_id', 
    class_name: 'FacilityMalariaGroupReport'

  belongs_to :health_facility
  belongs_to :workbook_file

  DEFAULT_SORTS = [{name: 'district_name', dir: 'asc'}]

  ELEMENT_DHIS2_MAPPING = {
    num_pregnant_anc_tested: 'hAvUxVyMvrN',
    num_pregnant_first_dose_sp: 'F0ne7Z8cMze',
    num_pregnant_three_doses_sp: 'nPFA2Jcgn0d',
    date_report_completed: 'OudJWfdmthW',
    date_report_submitted: 'mOg7hIbKT0H'
  }

  self.primary_key = 'id'

  def self.case_report params={}
    grouping = params[:grouping] || ['district']
    wheres = where_clause_and_params params, grouping
    q = %(
      #{select_clause grouping}
      #{from_clause grouping}
      #{wheres[:clause]}
      #{group_by_clause grouping}
      #{order_by_clause params}
    )
    find_by_sql [q, *wheres[:params]]
  end


  def dhis2_elements
    elements = dhis2_report_elements
    facility_inventory_reports.each do |r|
      elements += r.dhis2_elements
    end
    facility_malaria_group_reports.each do |r|
      elements += r.dhis2_elements
    end
    return elements
  end

  def dhis2_report_elements
    [
      {
        dataElement: ELEMENT_DHIS2_MAPPING[:num_pregnant_anc_tested],
        period: workbook_file.workbook.dhis2_period,
        orgUnit: health_facility.dhis2_id,
        value: num_pregnant_anc_tested || nil,
        followUp: false
      },
      {
        dataElement: ELEMENT_DHIS2_MAPPING[:num_pregnant_anc_tested],
        period: workbook_file.workbook.dhis2_period,
        orgUnit: health_facility.dhis2_id,
        value: num_pregnant_anc_tested || 0,
        followUp: false
      },
      {
        dataElement: ELEMENT_DHIS2_MAPPING[:num_pregnant_first_dose_sp],
        period: workbook_file.workbook.dhis2_period,
        orgUnit: health_facility.dhis2_id,
        value: num_pregnant_first_dose_sp || 0,
        followUp: false
      },
      {
        dataElement: ELEMENT_DHIS2_MAPPING[:num_pregnant_three_doses_sp],
        period: workbook_file.workbook.dhis2_period,
        orgUnit: health_facility.dhis2_id,
        value: num_pregnant_three_doses_sp || 0,
        followUp: false
      }
    ]
  end

  private

    def self.order_by_clause params
      clauses = []
      (params[:sorts] || DEFAULT_SORTS).each do |sort|
        if sort[:name] == 'district_name'
          clauses << "d.name #{sort[:dir] == 'desc' ? 'desc' : 'asc'}"
        elsif sort[:name] == 'health_facility_name'
          clauses << "hf.name #{sort[:dir] == 'desc' ? 'desc' : 'asc'}"
        elsif sort[:name] == 'reporting_year'
          clauses << "w.reporting_year #{sort[:dir] == 'desc' ? 'desc' : 'asc'}"
        elsif sort[:name] == 'reporting_month'
          clauses << "w.reporting_month #{sort[:dir] == 'desc' ? 'desc' : 'asc'}"
        end
      end
      return "ORDER BY " + clauses.join(", ")
    end

    def self.select_clause grouping=[]
      %(
        SELECT 
          #{'d.id as district_id,' if grouping.include?('district')}
          #{'d.name as district_name,' if grouping.include?('district')}
          #{'hf.id as health_facility_id,' if grouping.include?('health_facility') }
          #{'hf.name as health_facility_name,' if grouping.include?('health_facility') }
          #{'w.reporting_year as reporting_year,' if grouping.include?('reporting_year') }
          #{'w.reporting_month as reporting_month,' if grouping.include?('reporting_month') } 
          #{'w.id as workbook_id,' if grouping.include?('workbook') }
          SUM(fmgr.total_patients_all_causes) AS total_patients_all_causes,
          SUM(fmgr.suspect_simple_male) AS suspect_simple_male,
          SUM(fmgr.suspect_simple_female) AS suspect_simple_female,
          SUM(fmgr.suspect_severe_male) AS suspect_severe_male,
          SUM(fmgr.suspect_severe_female) AS suspect_severe_female,
          SUM(fmgr.tested_microscope) AS tested_microscope,
          SUM(fmgr.tested_rdt) AS tested_rdt,
          SUM(fmgr.confirmed_microscope) AS confirmed_microscope,
          SUM(fmgr.confirmed_rdt) AS confirmed_rdt,
          SUM(fmr.num_pregnant_anc_tested) AS num_pregnant_anc_tested,
          SUM(fmr.num_pregnant_first_dose_sp) AS num_pregnant_first_dose_sp,
          SUM(fmr.num_pregnant_three_doses_sp) AS num_pregnant_three_doses_sp,
          MAX(fmr.approved_by_date) AS latest_approved_by_date,

          SUM(fmgr.total_patients_all_causes) AS total_patients_all_causes,
          SUM(fmgr.suspect_simple_male) + SUM(fmgr.suspect_simple_female) +
            SUM(fmgr.suspect_severe_male) + SUM(fmgr.suspect_severe_female)
            AS suspected_cases,
          SUM(fmgr.tested_microscope) + SUM(fmgr.tested_rdt)
            AS total_tested,
          SUM(fmgr.confirmed_microscope) + SUM(fmgr.confirmed_microscope)
            AS total_tested_positive,
          (SUM(fmgr.tested_microscope) + SUM(fmgr.tested_rdt) - 
            SUM(fmgr.confirmed_microscope) + SUM(fmgr.confirmed_microscope))
            AS total_tested_negative,
          SUM(fmgr.treated_act_male) + SUM(fmgr.treated_act_female) + 
            SUM(fmgr.treated_severe_male) + SUM(fmgr.treated_severe_female)
            AS total_treated,

          (SUM(COALESCE(milda_fir.stock_month_start, 0)) + SUM(COALESCE(milda_fir.stock_month_received,0))) - 
            (SUM(COALESCE(milda_fir.num_delivered_to_ac,0)) + SUM(COALESCE(milda_fir.num_delivered_to_ps,0)) + 
              SUM(COALESCE(milda_fir.num_used,0)) + SUM(COALESCE(milda_fir.num_lost,0)))
            AS milda_distributed
      )
    end

    def self.from_clause grouping=[]
      %(
        FROM facility_monthly_reports fmr
        LEFT OUTER JOIN facility_malaria_group_reports fmgr 
          ON fmgr.workbook_facility_monthly_report_id = fmr.id
        LEFT OUTER JOIN facility_inventory_reports milda_fir
          ON milda_fir.workbook_facility_monthly_report_id = fmr.id 
            AND milda_fir.product = 'milda'
        LEFT OUTER JOIN workbook_files wf 
          ON wf.id = fmr.workbook_file_id
        LEFT OUTER JOIN workbooks w 
          ON w.id = wf.workbook_id
        LEFT OUTER JOIN districts d 
          ON d.id = w.district_id 
        LEFT OUTER JOIN health_facilities hf 
          ON hf.id = fmr.health_facility_id
      )
    end

    def self.group_by_clause grouping
      group_by = []
      group_by << 'd.id' if grouping.include?('district')
      group_by << 'w.id,' if grouping.include?('workbook')
      group_by << 'w.reporting_year,' if grouping.include?('reporting_year')
      group_by << 'w.reporting_month,' if grouping.include?('reporting_month')
      group_by << 'hf.id' if grouping.include?('health_facility')
      if group_by.empty?
        return ""
      else
        return "GROUP BY #{group_by.join(', ')}"
      end
    end

    def self.where_clause_and_params params, grouping=[]
      where_clauses = ["1=1"]
      where_params = []
      unless params[:district_id].blank?
        where_clauses << "w.district_id = ?"
        where_params << params[:district_id]
      end
      unless params[:health_facility_id].blank?
        where_clauses << "fmr.health_facility_id = ?"
        where_params << params[:health_facility_id]
      end
      unless params[:reporting_year].blank?
        unless params[:reporting_month].blank?
          where_clauses << "w.reporting_month = ?"
          where_params << params[:reporting_month]
        end
        where_clauses << "w.reporting_year = ?"
        where_params << params[:reporting_year]
      else 
        unless params[:start_year].blank?
          where_clauses << "w.reporting_year >= ?"
          where_params << params[:start_year]
          unless params[:start_month].blank?
            where_clauses << "w.reporting_month >= ?"
          where_params << params[:start_month]
          end
        end
        unless params[:end_year].blank?
          where_clauses << "w.reporting_year <= ?"
          where_params << params[:end_year]
          unless params[:end_month].blank?
            where_clauses << "w.reporting_month <= ?"
            where_params << params[:end_month]
          end
        end
      end
      unless params[:groups].blank?
        where_clauses << "fmr.group in (:groups)"
      end
      return {
        clause: "WHERE " + where_clauses.join(" AND "),
        params: where_params
      }
    end

end